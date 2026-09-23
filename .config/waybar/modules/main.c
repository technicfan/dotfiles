#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/un.h>

static void print_window(int sock, int port_len, char* port) {
    int msg = 3;
    send(sock, &msg, sizeof(int), 0);
    send(sock, &port_len, sizeof(int), 0);
    send(sock, port, port_len, 0);
    recv(sock, &msg, sizeof(int), 0);
    if (msg == 0) {
        recv(sock, &msg, sizeof(int), 0);
        char* window = malloc(msg + 1);
        recv(sock, window, msg, 0);
        window[msg] = '\0';
        printf("%s\n", window);
        free(window);
    }
}

int main(int argc, char *argv[]) {
    setbuf(stdout, NULL);
    char* port = getenv("WAYBAR_OUTPUT_NAME");
    if (port == NULL) {
        return EXIT_FAILURE;
    }
    int port_len = strlen(port);
    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock == -1) {
        printf("Unable to create socket\n");
        return EXIT_FAILURE;
    }
    struct sockaddr_un server_addr;
    server_addr.sun_family = AF_UNIX;
    char* socket_file;
    char* home = getenv("HOME");
    if (home != NULL) {
        socket_file = malloc(strlen(home) + 29);
        sprintf(socket_file, "%s/.config/qtile/waybar/socket", home);
    } else {
        return EXIT_FAILURE;
    }
    strcpy(server_addr.sun_path, socket_file);
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        printf("Unable to connect socket\n");
        return EXIT_FAILURE;
    }

    int msg;
    print_window(sock, port_len, port);
    while (1) {
        if (recv(sock, &msg, sizeof(int), 0) > 0 && msg == 1) {
            print_window(sock, port_len, port);
        }
    }

    return EXIT_SUCCESS;
}
