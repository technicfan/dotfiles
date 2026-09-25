#include "glib.h"
#include "gtk/gtk.h"
#include "waybar_cffi_module.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

typedef struct {
    wbcffi_module* waybar_module;
    GtkBox* container;
    int group_count;
    int active_group;
    struct group** groups;
    int show_empty;
    int signal;
    pthread_t thread;
    int stop;
    int socket;
    char* socket_file;
    struct node* active_args_head;
} QtileGroups;

struct args {
    QtileGroups* inst;
    char* groups;
};

struct node {
    void* val;
    struct node* next;
    struct node* previous;
};

struct group {
    char* label;
    GtkButton* button;
    int active;
    int visible;
    int empty;
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
            free(args);
            break;
        }
        current = current->next;
    }
}

static void clear_args(QtileGroups* inst) {
    struct node* next;
    struct node* current = inst->active_args_head->next;
    while (current != NULL) {
        g_idle_remove_by_data(current->val);
        next = current->next;
        free(current->val);
        free(current);
        current = next;
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
        int counter = 0;
        int new_group = inst->active_group;
        while (counter == 0
            || (inst->groups[new_group]->empty && counter <= inst->group_count)) {
            if (forwards) {
                if (new_group == inst->group_count - 1) {
                    new_group = 0;
                } else {
                    new_group++;
                }
            } else {
                if (new_group == 0) {
                    new_group = inst->group_count - 1;
                } else {
                    new_group--;
                }
            }
            counter++;
        }
        to_group(inst, inst->groups[new_group]->label);
    }
}

static void onclick(GtkButton* button, QtileGroups* inst) {
    to_group(inst, gtk_button_get_label(button));
}

static gboolean update(gpointer args) {
    QtileGroups* inst = (QtileGroups*) ((struct args*) args)->inst;
    char* groups = ((struct args*) args)->groups;
    if (groups) {
        int active = 0, visible = 0, empty = 0, read_tag = 0, name_index = 0, counter = 0;
        for (int i = 0, len = strlen(groups); i < len; i++) {
            if (read_tag) {
                if (groups[i] == 'a') {
                    active = 1;
                } else if (groups[i] == 'v') {
                    visible = 1;
                } else if (groups[i] == 'e') {
                    empty = 1;
                } else if (groups[i] == '>') {
                    read_tag = 0;
                }
                continue;
            }
            if (groups[i] == ';') {
                groups[name_index] = '\0';
                int new = inst->group_count == 0;
                if (new) {
                    inst->groups
                        = realloc(inst->groups, (counter + 1) * sizeof(struct group*));
                    struct group* group = malloc(sizeof(struct group));
                    group->label = malloc(name_index + 1);
                    strncpy(group->label, groups, name_index + 1);
                    GtkButton* button = GTK_BUTTON(gtk_button_new_with_label(group->label));
                    g_signal_connect(button, "clicked", G_CALLBACK(onclick), inst);
                    group->button = button;
                    group->active = 0;
                    group->visible = 0;
                    group->empty = 0;
                    gtk_container_add(GTK_CONTAINER(inst->container), GTK_WIDGET(button));
                    inst->groups[counter] = group;
                }
                struct group* group = inst->groups[counter];
                GtkButton* button = group->button;
                GtkStyleContext* style = gtk_widget_get_style_context(GTK_WIDGET(button));
                if (active && !group->active) {
                    gtk_style_context_add_class(style, "active");
                    inst->active_group = counter;
                }
                if (visible && !group->visible) {
                    gtk_style_context_add_class(style, "visible");
                }
                if (empty && !group->empty) {
                    gtk_style_context_add_class(style, "empty");
                }
                if (new) {
                    gtk_style_context_add_class(style, group->label);
                }
                if (!active && group->active) {
                    gtk_style_context_remove_class(style, "active");
                    if (inst->active_group == counter) {
                        inst->active_group = 0;
                    }
                }
                if (!visible && group->visible) {
                    gtk_style_context_remove_class(style, "visible");
                }
                if (!empty && group->empty) {
                    gtk_style_context_remove_class(style, "empty");
                }
                group->active = active;
                group->visible = visible;
                group->empty = empty;
                if (!inst->show_empty && group->empty) {
                    gtk_widget_hide(GTK_WIDGET(group->button));
                } else {
                    gtk_widget_show(GTK_WIDGET(group->button));
                }
                name_index = 0;
                active = 0;
                visible = 0;
                empty = 0;
                counter++;
            } else if (groups[i] == '<') {
                read_tag = 1;
            } else {
                groups[name_index] = groups[i];
                name_index++;
            }
        }
        if (inst->group_count == 0) {
            inst->group_count = counter;
        }
    } else {
        printf("Failed to get groups\n");
    }
    remove_arg(inst, args);
    free(groups);
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
    if (button != NULL) gtk_container_remove(GTK_CONTAINER(inst->container), GTK_WIDGET(button));
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
    gtk_widget_set_name(GTK_WIDGET(inst->container), "groups");
    inst->groups = NULL;
    inst->group_count = 0;

    inst->signal = -1;
    inst->show_empty = 0;
    inst->socket_file = NULL;
    for (int i = 0; i < config_entries_len; i++) {
        wbcffi_config_entry entry = config_entries[i];
        if (!strcmp(entry.key, "show-empty") && !strcmp(entry.value, "true\n")) {
            inst->show_empty = 1;
        } else if (!strcmp(entry.key, "signal")) {
            inst->signal = atoi(entry.value);
        } else if (!strcmp(entry.key, "socket")) {
            int len = strlen(entry.value);
            inst->socket_file = malloc(len - 2);
            memcpy(inst->socket_file, entry.value + sizeof(char), (len - 3) * sizeof(char));
            inst->socket_file[len - 3] = '\0';
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
    inst->active_args_head = malloc(sizeof(struct node));
    inst->active_args_head->next = NULL;
    inst->active_args_head->previous = NULL;
    inst->active_args_head->val = NULL;
    setup_socket(NULL, inst);

    if (inst->socket == -1) {
        GtkButton* button = GTK_BUTTON(
            gtk_button_new_with_label("No socket connection (Click to retry)")
        );
        GtkStyleContext* style = gtk_widget_get_style_context(GTK_WIDGET(button));
        gtk_style_context_add_class(style, "error");
        gtk_container_add(GTK_CONTAINER(inst->container), GTK_WIDGET(button));
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
    free(inst->active_args_head);
    for (int i = 0; i < inst->group_count; i++) {
        free(inst->groups[i]->label);
        free(inst->groups[i]);
    }
    free(inst->groups);
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
