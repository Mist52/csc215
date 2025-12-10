#include <stdio.h>

#define MAXLINE 1024

reverse(s)
char s[];
{
    int i, j, len;
    char temp;
    
    /* Find length of string */
    len = 0;
    while (s[len] != '\0')
        len++;
    
    /* Remove trailing newline if present */
    if (len > 0 && s[len - 1] == '\n') {
        s[len - 1] = '\0';
        len--;
    }
    
    /* Reverse the string in place */
    for (i = 0, j = len - 1; i < j; i++, j--) {
        temp = s[i];
        s[i] = s[j];
        s[j] = temp;
    }
}

main(argc, argv)
char *argv[];
{
    FILE *fp;
    char linbuf[MAXLINE];
    
    if (argc != 2) {
        printf("Usage: backward filename <cr>\n");
        exit();
    }
    
    if ((fp = fopen(argv[1], "r")) == NULL) {
        printf("Can't open %s\n", argv[1]);
        exit();
    }
    
    while (fgets(linbuf, MAXLINE, fp)) {
        reverse(linbuf);
        printf("%s\n", linbuf);
    }
    
    fclose(fp);
}


