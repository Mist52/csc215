#include <stdio.h>

#define MAXLINE 1024

main(argc, argv)
char *argv[];
{
    FILE *fp;
    char linbuf[MAXLINE];
    int charcount, i;
    
    if (argc != 2) {
        printf("Usage: chrnums filename <cr>\n");
        exit();
    }
    
    if ((fp = fopen(argv[1], "r")) == NULL) {
        printf("Can't open %s\n", argv[1]);
        exit();
    }
    
    while (fgets(linbuf, MAXLINE, fp)) {
        /* Count characters in line */
        charcount = 0;
        for (i = 0; linbuf[i] != '\0'; i++)
            charcount++;
        printf("%d: %s", charcount, linbuf);
    }
    
    fclose(fp);
}



