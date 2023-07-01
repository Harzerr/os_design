#include "myos.h"
int _mymain()
{
	char ch;
	setmode(3);
	initdisp();
	initIRQ1C();

	//printdata(12);
	//enter();
	printIVT();
	enter();	
	vlen = 0;
		prompt();
	for(;;){
		readcmd();
		enter();
		prompt();		
	}
}
			
