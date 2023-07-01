__asm__(".code16gcc\n");
extern int puts(char *str);
extern int setmode(char mode);
extern int initdisp();
extern int prompt();
extern int myputc(char ch);
extern char mygetc();
int printdata(unsigned short int n);
int readcommand();
int readcmd();
extern int enter();
extern int initIRQ1C(); 
extern int printIVT();
static char command[60];
	