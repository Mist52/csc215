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

void itoa_ptr(int n, char *s) {
    int sign;
    char *p = s;
    
    if ((sign = n) < 0)
        n = -n;
    
    do {
        *p++ = n % 10 + '0';
    } while ((n /= 10) > 0);
    
    if (sign < 0)
        *p++ = '-';
    
    *p = '\0';
    reverse_ptr(s);
}

void reverse_ptr(char *s) {
    char c, *p;
    

    for (p = s; *p; p++);
    
    p--; 
    

    while (s < p) {
        c = *s;
        *s++ = *p;
        *p-- = c;
    }
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
