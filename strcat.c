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
int atoi_ptr(char *s) {
    int n = 0;
    
    while (*s >= '0' && *s <= '9')
        n = 10 * n + (*s++ - '0');
    
    return n;
}

void itoa(int n, char s[]) {
    int i, sign;
    if ((sign = n) < 0)
        n = -n;
    i = 0;
    do {
        s[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);
    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';
    reverse(s);
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
