#include "key.h"
int readcommand()
{
	char ch = 0, len = 0;
	while (ch != 0x0d && len < 60){
		ch = mygetc();
		if (ch != 0x0d){
			if ((ch >= 'A' && ch <='Z')
			   ||(ch >= 'a' && ch <='z')
			   ||(ch >= '0' && ch <='9')){
				myputc(ch);
				command[len] = ch;
				len = len + 1;
			}
			if (ch == 0x08 && len > 0){
				myputc(ch);
				myputc(' ');
				myputc(ch);
				len = len - 1;
				command[len] = 0;
			}			
		}
		else enter();
	}
	command[len] = 0;
	len = 0;
	while (command[len] != 0){
		ch = command[len];
		myputc(ch);
		len = len + 1;
	}
	return 0; 
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
	command[len] = 0;
	len = 0;
	while (command[len] != 0){
		ch = command[len];
		myputc(ch);
		len = len + 1;
	}
	return 0; 
}					