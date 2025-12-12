#include <stdio.h>
#include <string.h>

/* Concatenate t to end of s, return pointer to s */
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

/* Convert string to integer */
int atoi_ptr(char *s) {
    int n = 0;
    
    while (*s >= '0' && *s <= '9')
        n = 10 * n + (*s++ - '0');
    
    return n;
}

/* Reverse string in place */
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

/* Convert integer to string */
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

main()
{
    char buffer[100];
    char result[100];
    char numstr[20];
    int num1, num2;
    
    printf("=== Pointer Function Demonstrations ===\n\n");
    
    /* Demo 1: strcatp */
    printf("1. String Concatenation (strcatp):\n");
    strcpy(buffer, "Hello");
    strcatp(buffer, ", World!");
    printf("   Demo 1a: %s\n", buffer);
    
    strcpy(buffer, "Year: ");
    strcatp(buffer, "2025");
    printf("   Demo 1b: %s\n\n", buffer);
    
    /* Demo 2: reverse_ptr */
    printf("2. String Reversal (reverse_ptr):\n");
    strcpy(result, "ABCDEFG");
    printf("   Demo 2a: %s -> ", result);
    reverse_ptr(result);
    printf("%s\n", result);
    
    strcpy(result, "racecar");
    printf("   Demo 2b: %s -> ", result);
    reverse_ptr(result);
    printf("%s\n\n", result);
    
    /* Demo 3: itoa_ptr */
    printf("3. Integer to String (itoa_ptr):\n");
    itoa_ptr(12345, numstr);
    printf("   Demo 3a: 12345 -> \"%s\"\n", numstr);
    
    itoa_ptr(-9876, numstr);
    printf("   Demo 3b: -9876 -> \"%s\"\n\n", numstr);
    
    /* Demo 4: atoi_ptr */
    printf("4. String to Integer (atoi_ptr):\n");
    num1 = atoi_ptr("42");
    printf("   Demo 4a: \"42\" -> %d\n", num1);
    
    num2 = atoi_ptr("1984");
    printf("   Demo 4b: \"1984\" -> %d\n", num2);
    
    return 0;
}


