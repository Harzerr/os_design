#include "myos.h"
int _mymain()
{
	char ch;
	setmode(3);
	initdisp();
	initIRQ1C();
	prompt();
	printdata(12);
	enter();
	printIVT();
	enter();	
	for(;;){
		readcmd();
		enter();
		prompt();		
	}
}
			