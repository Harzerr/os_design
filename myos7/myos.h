__asm__(".code16gcc\n");

#define enterkey 0x0d

extern int puts(char *str);
extern int setmode(); 
extern int initdisplay(); 
extern int initdisp();
extern int prompt();
extern int myputc(char ch);
extern char mygetc();
extern int printdata(unsigned short int n);
extern int printdata1(unsigned short int n);
extern int readcmd();
extern int readcommand();
extern int enter();
extern int cursorleft();
extern int cursorright();
extern int gettime();
