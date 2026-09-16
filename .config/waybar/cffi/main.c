
#include "glib-object.h"
#include "glib.h"
#include "gtk/gtk.h"
#include "waybar_cffi_module.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdatomic.h>
#include <sys/inotify.h>
#include <pthread.h>
#include <curl/curl.h>
#include <unistd.h>

typedef struct {
    wbcffi_module* waybar_module;
    GtkBox* container;
    GtkBox* groups;
    int show_empty;
    int signal;
    const char* endpoint;
    char* status_file;
    pthread_t thread;
    int stop;
} QtileGroups;

// This static variable is shared between all instances of this module
static int instance_count = 0;

#define BUF_LEN (10 * (sizeof(struct inotify_event) + NAME_MAX + 1))

typedef struct {
    char* val;
    size_t len;
} string;

static size_t write_response(void* contents, size_t size, size_t nmemb, string* response){
    size_t new_len = response->len + size * nmemb;
    char* temp = realloc(response->val, new_len + 1);
    if (temp == NULL) return 0;
    free(response->val);
    response->val = temp;
    memcpy(response->val + response->len, contents, size * nmemb);
    response->val[new_len] = '\0';
    response->len = new_len;
    return size * nmemb;
}

static void cycle(QtileGroups* inst, int forwards) {
    CURL* curl = curl_easy_init();
    char* url = malloc(strlen(inst->endpoint) + (forwards ? 15 : 16));
    sprintf(url, "%s/cycle/%s", inst->endpoint, forwards ? "forwards" : "backwards");
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");
    if (curl_easy_perform(curl) != CURLE_OK) {
        printf("Failed to cycle %s\n", forwards ? "forwards" : "backwards");
    }
    curl_easy_cleanup(curl);
    free(url);
}

static void togroup(GtkButton* button, void* arg) {
    QtileGroups* inst = (QtileGroups*) arg;
    CURL* curl = curl_easy_init();
    const char* label = gtk_button_get_label(button);
    char* url = malloc(strlen(label) + strlen(inst->endpoint) + 8);
    sprintf(url, "%s/switch/%s", inst->endpoint, label);
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");
    if (curl_easy_perform(curl) != CURLE_OK) {
        printf("Failed to switch to group %s\n", label);
    }
    curl_easy_cleanup(curl);
    free(url);
}

static gboolean update(gpointer data) {
    QtileGroups* inst = (QtileGroups*) data;
    // idk...
    if (inst->show_empty != 0 && inst->show_empty != 1) return G_SOURCE_REMOVE;
    CURL* curl = curl_easy_init();
    string* response = malloc(sizeof(string));
    response->len = 0;
    response->val = NULL;
    char* url = malloc(strlen(inst->endpoint) + (inst->show_empty ? 12 : 13));
    sprintf(url, "%s/groups/%s", inst->endpoint, inst->show_empty ? "true" : "false");
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_response);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, response);
    if (curl_easy_perform(curl) == CURLE_OK) {
        if (inst->groups != NULL) {
            gtk_container_remove(GTK_CONTAINER(inst->container), GTK_WIDGET(inst->groups));
        }
        inst->groups = GTK_BOX(gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0));
        gtk_container_add(GTK_CONTAINER(inst->container), GTK_WIDGET(inst->groups));
        char group_name[strlen(response->val)];
        int primary = 0, secondary = 0, read_tag = 0, name_index = 0;
        for (int i = 0; i < strlen(response->val); i++) {
            if (read_tag) {
                if (response->val[i] == 'p') {
                    primary = 1;
                } else if (response->val[i] == 's') {
                    secondary = 1;
                } else if (response->val[i] == '>') {
                    if (primary || secondary) {
                        read_tag = 0;
                    } 
                }
                continue;
            }
            if (response->val[i] == ';') {
                GtkButton* button = GTK_BUTTON(gtk_button_new_with_label(group_name));
                g_signal_connect(button, "clicked", G_CALLBACK(togroup), inst);
                GtkStyleContext* style = gtk_widget_get_style_context(GTK_WIDGET(button));
                gtk_style_context_add_class(style, "qtile-group");
                if (primary) {
                    gtk_style_context_add_class(style, "qtile-primary");
                } else if (secondary) {
                    gtk_style_context_add_class(style, "qtile-secondary");
                }
                gtk_container_add(GTK_CONTAINER(inst->groups), GTK_WIDGET(button));
                name_index = 0;
                primary = 0;
                secondary = 0;
            } else if (response->val[i] == '<') {
                read_tag = 1;
            } else {
                group_name[name_index] = response->val[i];
                group_name[name_index + 1] = '\0';
                name_index++;
            }
        }
    } else {
        printf("Failed to GET the groups\n");
    }
    gtk_widget_show_all(GTK_WIDGET(inst->groups));
    curl_easy_cleanup(curl);
    free(url);
    free(response->val);
    free(response);
    return G_SOURCE_REMOVE;
}

const size_t wbcffi_version = 2;

void* update_watcher(void* arg) {
    QtileGroups* inst = (QtileGroups*) arg;
    char buf[BUF_LEN] __attribute__ ((aligned(8)));
    int inotify = inotify_init();
    if (inotify == -1 || inotify_add_watch(inotify, inst->status_file, IN_OPEN) == -1) {
        printf("Failed to watch %s\n", inst->status_file);
    }

    while (!inst->stop) {
        if (read(inotify, buf, BUF_LEN) > 0) {
            g_idle_add(update, inst);
        }
    }
    return NULL;
}

void* wbcffi_init(const wbcffi_init_info* init_info, const wbcffi_config_entry* config_entries, size_t config_entries_len) {
    QtileGroups* inst = malloc(sizeof(QtileGroups));
    inst->waybar_module = init_info->obj;

    GtkContainer* root = init_info->get_root_widget(init_info->obj);

    inst->container = GTK_BOX(gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0));
    gtk_container_add(GTK_CONTAINER(root), GTK_WIDGET(inst->container));
    inst->groups = NULL;

    inst->signal = 0;
    inst->show_empty = 0;
    inst->endpoint = NULL;
    inst->status_file = NULL;
    for (int i = 0; i < config_entries_len; i++) {
        wbcffi_config_entry entry = config_entries[i];
        if (!strcmp(entry.key, "show-empty") && !strcmp(entry.value, "true")) {
            inst->show_empty = 1;
        } else if (!strcmp(entry.key, "signal")) {
            inst->signal = atoi(entry.value);
        } else if (!strcmp(entry.key, "status-file")) {
            inst->status_file = malloc(strlen(entry.value));
            strcpy(inst->status_file, entry.value);
        } else if (!strcmp(entry.key, "endpoint")) {
            inst->endpoint = entry.value;
        }
    }
    if (inst->status_file == NULL) {
        char* home = getenv("HOME");
        if (home != NULL) {
            inst->status_file = malloc(strlen(home) + 36);
            sprintf(inst->status_file, "%s/.config/qtile/waybar/group-change", home);
        }
    }
    if (inst->status_file == NULL) {
        printf("Unable to set status-file\n");
        inst->status_file = "";
    }
    if (inst->endpoint == NULL) {
        inst->endpoint = "http://localhost:3001";
    }

    update(inst);
    inst->stop = 0;
    pthread_create(&inst->thread, NULL, update_watcher, inst);

    instance_count++;
    return inst;
}

void wbcffi_deinit(void* instance) {
    QtileGroups* inst = (QtileGroups*) instance;
    inst->stop = 1;
    FILE* file = fopen(inst->status_file, "r");
    if (file != NULL) {
        fclose(file);
    }
    pthread_join(inst->thread, NULL);
    free(inst->status_file);
    free(instance);
}

void wbcffi_refresh(void* instance, int signal) {
    QtileGroups* inst = (QtileGroups*) instance;
    if (signal == inst->signal) {
        g_idle_add(update, inst);
    }
}

void wbcffi_doaction(void* instance, const char* name) {
    if (!strcmp(name, "cycle forwards")) {
        cycle(instance, 1);
    } else if (!strcmp(name, "cycle backwards")) {
        cycle(instance, 0);
    }
}
