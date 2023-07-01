#include "myos.h" 
char ch;
int printdata1(unsigned short int n);
int _mymain()
{
	setmode(3);
	initdisplay();
	prompt();
	/*enter();
	enter();*/
	//printdata1(123);
	//myputc('4');
	gettime();
	for(;;){
		/*ch = mygetc();
		myputc(ch); */
		readcmd();
		prompt();
	}
}
