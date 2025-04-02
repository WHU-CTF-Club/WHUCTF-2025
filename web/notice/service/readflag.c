#include <stdio.h>

int main() {
    FILE *file;
    int c;

    file = fopen("/flag.txt", "r");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }
    while ((c = fgetc(file)) != EOF) {
        putchar(c);
    }
    fclose(file);

    return 0;
}
