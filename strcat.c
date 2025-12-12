#include <stdio.h>
#include <string.h>


char *strcatp(s, t)
char *s;
char *t;
{
    char *ret;
    ret = s;           

    while (*s != '\0')     
        s++;

    for (;;) {            
        *s = *t;
        if (*t == '\0')
            break;
        s++;
        t++;
    }

    return ret;
}

int atoi(char s[]) {
    int i, n;
    n = 0;
    for (i = 0; s[i] >= '0' && s[i] <= '9'; ++i)
        n = 10 * n + (s[i] - '0');
    return n;
}



main()
{
    char dest[40];          
    char *src;
    src = "Hello, CP/M!";


    strcpy(dest, src);
    printf("%s\n", dest);

    strcatp(dest, " Howdy");
    printf("%s\n", dest);

    return 0;
}
