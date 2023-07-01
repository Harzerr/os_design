__asm__(".code16gcc\n");
extern int puts(char * str);
extern int setmode(); 
extern int initdisplay(); 
extern int initdisp();
extern int prompt();
extern int myputc(char ch);
short int printdata(unsigned short int n);
char * str = "fgfh";
int _mymain()
{
	//puts(str);
	setmode(3);
	initdisplay();
	prompt();
	printdata(123);
	for(;;);
}
short int printdata(unsigned short int n)
{
	int tt = 0; 
	while(n){
		tt = tt*10 + (n % 10);
		n /= 10;
	}
	while(tt){
		myputc((tt%10) + 0x30);
		tt /= 10;
	}
	
	return 0;
}
