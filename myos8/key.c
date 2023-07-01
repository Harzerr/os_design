#include "key.h"

int readcommand()
{
	char ch = 0, cursor = 0;
	char x, i;
	while (ch != 0x0d && vlen < 100){
		ch = mygetc();
		vstr[vlen] = ch;
		vlen += 1;
		myputc(ch);
	}
	
	if(len > 0){
		vstr[vlen] = 0;
		len = 0;
		enter();
		myputc('y');
		myputc('o');
		myputc('u');
		myputc('-');
		myputc('t');
		myputc('y');
		myputc('p');
		myputc('e');
		myputc('-');
		myputc('n');
		myputc('e');
		myputc('w');	
		myputc(':');	
		while (vstr[vlen] != 0) {
			ch = vstr[vlen];
			myputc(ch);
			vlen = vlen + 1;
		}
		writedisk(&vstr[0]); 
		enter();
//		readdisk();
//		enter();
//		enter();
//		len = 0;
//		while (vstr[len] != 0) {
//			ch = vstr[len];
//			myputc(ch);
//			len = len + 1;
//		}
//		return 1;
	}
	return 0;
} 

int cmp() {
	int i = 0;
	if(command[i] == 't' &&  command[i+1] == 'i' && command[i+2] == 'm' &&command[i+3] == 'e') 
		return 1;
	if (command[i] == 'e' && command[i + 1] == 'd' && command[i + 2] == 'i' && command[i + 3] == 't')
		return 2;
    if (command[i] == 'h' && command[i + 1] == 'e' && command[i + 2] == 'l' && command[i + 3] == 'p')
		return 3;
	return 0;
}
void  timecmd() {
	timecmdd();
}
void editcmd() {
	 readcommand();
}
void helpcmd(){
	puts("total cmd : 2");
	enter();
	puts("edit");
	enter();
	puts("time");
	enter();
}
int readcmd()
{
	char ch = 0, len = 0, cursor = 0;
	char x, i;
	for (i = 0; i < 60; i++)
		command[i] = 0;
	while (ch != 0x0d && len < 60){
		ch = mygetc();
		if (ch != 0x0d){
			if ((ch >= 'A' && ch <='Z')
			   ||(ch >= 'a' && ch <='z')
			   ||(ch >= '0' && ch <='9')){
				for (i = cursor; i < len; i++){
					myputc(ch);
					x = ch;
					ch = command[i];
					command[i] = x;
				}	
				myputc(ch);
				command[len] = ch;
				len = len + 1;
				cursor = cursor + 1;
				for (i = 0; i < len - cursor; i++)
					cursorleft();
			}			
			if (_sysscancode == 0x4b && cursor > 0){
				cursorleft();
				cursor = cursor - 1;
			}
			if (_sysscancode == 0x4d && cursor < len){
				cursorright();
				cursor = cursor + 1;
			}
			if (_sysscancode == 0x53 && cursor < len){
				for (i = cursor; i < len ; i++){
					ch = command[i+1];
					command[i] = ch;
					myputc(ch);				
				}
				for (i = 0; i < len - cursor; i++)
					cursorleft();
				len = len - 1;
				command[len] = 0;
			}
			if (_sysscancode == 0x0e && cursor > 0){
				if (cursor == len){
					cursorleft();
					myputc(' ');
				} else
				for (i = cursor; i < len; i++){
					ch = command[i];
					command[i-1] = ch;
					cursorleft();
					myputc(ch);
					myputc(' ');				
				}
				cursor = cursor - 1;
				for (i = 0; i < len - cursor; i++)
					cursorleft();
				len = len - 1;
				command[len] = 0;
			}		
		}
		else enter();
	}
	
	int flag = cmp();
	if (flag == 1) {
		timecmd();
	}
	else if (flag == 2) {
		editcmd();
	}
	else if(flag == 3){
		helpcmd();
	}
	else {
		command[len] = 0;
		len = 0;
		while (command[len] != 0) {
			ch = command[len];
			myputc(ch);
			len = len + 1;
		}
	}
	
	
	//writedisk(&command[0]); 
	return 0; 
}					
