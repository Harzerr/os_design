__asm__(".code16gcc\n");
extern int cursorleft();
extern int cursorright();
extern int ascandsyscode();


char vstr[60]; 
int vlen;


extern int writedisk(char *str);
extern int readdisk();
char _sysscancode;

#include "myos.h"
