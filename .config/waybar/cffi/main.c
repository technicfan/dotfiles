#include "glib.h"
#include "gtk/gtk.h"
#include "waybar_cffi_module.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>

typedef struct {
    wbcffi_module* waybar_module;
    GtkBox* container;
    GtkBox* groups;
    int group_count;
    int current_group;
    char** group_names;
    int show_empty;
    int signal;
    pthread_t thread;
    int stop;
    int socket;
    char* socket_file;
    struct node* active_args_head;
} QtileGroups;

typedef struct {
    char* val;
    size_t len;
} data;

struct args {
    QtileGroups* inst;
    char* groups;
};

struct node {
    struct args* val;
    struct node* next;
    struct node* previous;
};

static void add_arg(QtileGroups* inst, struct args* args) {
    struct node* node = malloc(sizeof(struct node));
    node->val = args;
    if (inst->active_args_head->next == NULL) {
        node->next = NULL;
    } else {
        node->next = inst->active_args_head->next;
        node->next->previous = node;
    }
    inst->active_args_head->next = node;
    node->previous = inst->active_args_head;
}

static void remove_arg(QtileGroups* inst, struct args* args) {
    if (args == NULL) return;
    struct node* current = inst->active_args_head->next;
    while (current != NULL) {
        if (current->val == args) {
            current->previous->next = current->next;
            if (current->next != NULL) {
                current->next->previous = current->previous;
            }
            free(current);
            break;
        }
        current = current->next;
    }
}

static void clear_args(QtileGroups* inst) {
    struct node* current = inst->active_args_head->next;
    while (current != NULL) {
        g_idle_remove_by_data(current->val);
        current = current->next;
        free(current);
    }
}

static void to_group(QtileGroups* inst, const char* label) {
    int msg = 2;
    send(inst->socket, &msg, sizeof(int), 0);
    msg = strlen(label);
    send(inst->socket, &msg, sizeof(int), 0);
    send(inst->socket, label, msg, 0);
}

static char* get_groups(QtileGroups* inst) {
    int msg = 1;
    send(inst->socket, &msg, sizeof(int), 0);
    msg = inst->show_empty;
    send(inst->socket, &msg, sizeof(int), 0);
    recv(inst->socket, &msg, sizeof(int), 0);
    if (msg == 0) {
        int size;
        recv(inst->socket, &size, sizeof(int), 0);
        char* result = malloc(size + 1);
        recv(inst->socket, result, size, 0);
        result[size] = '\0';
        return result;
    } else {
        return NULL;
    }
}

static void request_update(int socket) {
    int msg = 0;
    send(socket, &msg, sizeof(int), 0);
    send(socket, &msg, sizeof(int), 0);
}

static void cycle(QtileGroups* inst, int forwards) {
    if (inst->group_count >= 2) {
        int new_group = inst->current_group;
        if (forwards) {
            if (inst->current_group == inst->group_count - 1) {
                new_group = 0;
            } else {
                new_group++;
            }
        } else {
            if (inst->current_group == 0) {
                new_group = inst->group_count - 1;
            } else {
                new_group--;
            }
        }
        to_group(inst, inst->group_names[new_group]);
    }
}

static void onclick(GtkButton* button, QtileGroups* inst) {
    to_group(inst, gtk_button_get_label(button));
}

static gboolean update(gpointer args) {
    QtileGroups* inst = (QtileGroups*) ((struct args*) args)->inst;
    char* groups = ((struct args*) args)->groups;
    if (groups) {
        if (inst->groups != NULL) {
            gtk_container_remove(GTK_CONTAINER(inst->container), GTK_WIDGET(inst->groups));
        }
        inst->groups = GTK_BOX(gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0));
        gtk_widget_set_name(GTK_WIDGET(inst->groups), "qtile-groups");
        gtk_container_add(GTK_CONTAINER(inst->container), GTK_WIDGET(inst->groups));
        for (int i = 0; i < inst->group_count; i++) {
            free(inst->group_names[i]);
        }
        free(inst->group_names);
        inst->group_names = NULL;
        int primary = 0, secondary = 0, read_tag = 0, name_index = 0, counter = 0;
        for (int i = 0, len = strlen(groups); i < len; i++) {
            if (read_tag) {
                if (groups[i] == 'p') {
                    primary = 1;
                } else if (groups[i] == 's') {
                    secondary = 1;
                } else if (groups[i] == '>') {
                    if (primary || secondary) {
                        read_tag = 0;
                    } 
                }
                continue;
            }
            if (groups[i] == ';') {
                groups[name_index] = '\0';
                GtkButton* button = GTK_BUTTON(gtk_button_new_with_label(groups));
                g_signal_connect(button, "clicked", G_CALLBACK(onclick), inst);
                gtk_widget_set_name(GTK_WIDGET(button), "qtile-groups");
                GtkStyleContext* style = gtk_widget_get_style_context(GTK_WIDGET(button));
                gtk_style_context_add_class(style, "qtile-group");
                if (primary) {
                    gtk_style_context_add_class(style, "qtile-primary");
                    inst->current_group = counter;
                } else if (secondary) {
                    gtk_style_context_add_class(style, "qtile-secondary");
                }
                gtk_container_add(GTK_CONTAINER(inst->groups), GTK_WIDGET(button));
                inst->group_names = realloc(inst->group_names, (counter + 1) * sizeof(char*));
                inst->group_names[counter] = malloc(name_index + 1);
                strncpy(inst->group_names[counter], groups, name_index + 1);
                name_index = 0;
                primary = 0;
                secondary = 0;
                counter++;
            } else if (groups[i] == '<') {
                read_tag = 1;
            } else {
                groups[name_index] = groups[i];
                name_index++;
            }
        }
        inst->group_count = counter;
    } else {
        printf("Failed to GET the groups\n");
    }
    gtk_widget_show_all(GTK_WIDGET(inst->groups));
    remove_arg(inst, args);
    free(groups);
    free(args);
    return G_SOURCE_REMOVE;
}

const size_t wbcffi_version = 2;

void* update_watcher(void* arg) {
    QtileGroups* inst = (QtileGroups*) arg;

    int msg;
    while (!inst->stop) {
        if (read(inst->socket, &msg, sizeof(int)) > 0 && msg == 0) {
            struct args* args = malloc(sizeof(struct args));
            args->inst = inst;
            args->groups = get_groups(inst);
            add_arg(inst, args);
            g_idle_add(update, args);
        }
    }

    return NULL;
}

static void setup_socket(GtkButton* button, QtileGroups* inst) {
    if (inst->socket_file == NULL) return;
    inst->socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (inst->socket == -1) {
        printf("Socket creation failed\n");
        return;
    }
    struct sockaddr_un server;
    server.sun_family = AF_UNIX;
    strcpy(server.sun_path, inst->socket_file);
    if (connect(inst->socket, (struct sockaddr*) &server, sizeof(server)) == -1) {
        printf("Socket connection failed\n");
        inst->socket = -1;
        return;
    }

    request_update(inst->socket);
    inst->stop = 0;
    pthread_create(&inst->thread, NULL, update_watcher, inst);
}

void* wbcffi_init(
    const wbcffi_init_info* init_info,
    const wbcffi_config_entry* config_entries,
    size_t config_entries_len
) {
    QtileGroups* inst = malloc(sizeof(QtileGroups));
    inst->waybar_module = init_info->obj;

    GtkContainer* root = init_info->get_root_widget(init_info->obj);

    inst->container = GTK_BOX(gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0));
    gtk_container_add(GTK_CONTAINER(root), GTK_WIDGET(inst->container));
    inst->groups = NULL;
    inst->group_count = 0;
    inst->current_group = 0;
    inst->group_names = NULL;

    inst->signal = -1;
    inst->show_empty = 0;
    inst->socket_file = NULL;
    for (int i = 0; i < config_entries_len; i++) {
        wbcffi_config_entry entry = config_entries[i];
        if (!strcmp(entry.key, "show-empty") && !strcmp(entry.value, "true")) {
            inst->show_empty = 1;
        } else if (!strcmp(entry.key, "signal")) {
            inst->signal = atoi(entry.value);
        } else if (!strcmp(entry.key, "socket")) {
            inst->socket_file = malloc(strlen(entry.value) + 1);
            strcpy(inst->socket_file, entry.value);
        }
    }
    if (inst->socket_file == NULL) {
        char* home = getenv("HOME");
        if (home != NULL) {
            inst->socket_file = malloc(strlen(home) + 29);
            sprintf(inst->socket_file, "%s/.config/qtile/waybar/socket", home);
        } else {
            printf("$HOME is not present\n");
        }
    }

    inst->socket = -1;
    setup_socket(NULL, inst);
    inst->active_args_head = malloc(sizeof(struct node));
    inst->active_args_head->next = NULL;
    inst->active_args_head->previous = NULL;
    inst->active_args_head->val = NULL;

    if (inst->socket == -1) {
        inst->groups = GTK_BOX(gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0));
        gtk_widget_set_name(GTK_WIDGET(inst->groups), "qtile-groups");
        gtk_container_add(GTK_CONTAINER(inst->container), GTK_WIDGET(inst->groups));
        GtkButton* button = GTK_BUTTON(
            gtk_button_new_with_label("No socket connection (Click to retry)")
        );
        gtk_widget_set_name(GTK_WIDGET(button), "qtile-groups");
        GtkStyleContext* style = gtk_widget_get_style_context(GTK_WIDGET(button));
        gtk_style_context_add_class(style, "qtile-group");
        gtk_container_add(GTK_CONTAINER(inst->groups), GTK_WIDGET(button));
        g_signal_connect(button, "clicked", G_CALLBACK(setup_socket), inst);
    }

    return inst;
}

void wbcffi_deinit(void* instance) {
    QtileGroups* inst = (QtileGroups*) instance;
    inst->stop = 1;
    if (inst->socket != -1) {
        request_update(inst->socket);
        pthread_join(inst->thread, NULL);
    }
    clear_args(inst);
    for (int i = 0; i < inst->group_count; i++) {
        free(inst->group_names[i]);
    }
    free(inst->group_names);
    free(inst->socket_file);
    close(inst->socket);
    free(instance);
}

void wbcffi_refresh(void* instance, int signal) {
    QtileGroups* inst = (QtileGroups*) instance;
    if (signal == inst->signal) {
        request_update(inst->socket);
    }
}

void wbcffi_doaction(void* instance, const char* name) {
    if (!strcmp(name, "cycle forwards")) {
        cycle(instance, 1);
    } else if (!strcmp(name, "cycle backwards")) {
        cycle(instance, 0);
    }
}
