#include <stdarg.h>
#include <stdio.h>

void die(char *format, ... ) {
printf("\nError in Stride\n");
void exit(int return_code);
va_list ptr;
va_start(ptr,format);
vfprintf(stderr,format,ptr);
//exit(1);
va_end(ptr);
}

