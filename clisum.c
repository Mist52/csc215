#include <stdio.h>

main(argc, argv)
int argc;  
char **argv; 
{
    int sum;     
    int i;       
    int invalid; 
    int value;   

    sum = 0;
    invalid = 0;

    for (i = 1; i < argc; ++i) {
        char *p;
        int negative;

        p = argv[i];
        value = 0;
        negative = 0;

    
        while (*p == ' ' || *p == '\t')
            p++;

        
        if (*p == '-') {
            negative = 1;
            p++;
        }

        
        if (*p < '0' || *p > '9') {
            printf("OOPS! %s is not a number", argv[i]);
            invalid = 1;
            break;
        }

        
        while (*p >= '0' && *p <= '9') {
            value = value * 10 + (*p - '0');
            p++;
        }

        
        while (*p == ' ' || *p == '\t')
            p++;

        
        if (*p != '\0') {
            printf("OOPS! %s is not a number", argv[i]);
            invalid = 1;
            break;
        }

        if (negative)
            value = -value;
        sum += value;
    }

    if (!invalid)
        printf("Sum is %d", sum);
}
