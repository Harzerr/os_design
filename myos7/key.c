#include "key.h"
char command[100];

int readcommand()
{
	char ch = 0, len = 0;
	while (ch != 0x0d && len < 60) {
		ch = mygetc();
		if (ch != 0x0d) {
			if ((ch >= 'A' && ch <= 'Z')
				|| (ch >= 'a' && ch <= 'z')
				|| (ch >= '0' && ch <= '9')) {
				myputc(ch);
				command[len] = ch;
				len = len + 1;
			}
			if (ch == 0x08 && len > 0) {
				myputc(ch);
				myputc(' ');
				myputc(ch);
				len = len - 1;
				command[len] = 0;
			}
		}
	}
	command[len] = 0;
	len = 0;
	while (command[len] != 0) {
		ch = command[len];
		myputc(ch);
		len = len + 1;
	}
	return 0;
}
int iscmd() {
	int len = 0;
	while (command[len] != 0) {
		len++;
	}
	int i = 0;
	while(command[i] == ' ' && i < len){
		i++;
	}
	//for (; i < len; i++) {
		if (i+3==len-1 && (command[i] == 'h' && command[i + 1] == 'e' && command[i + 2] == 'l' && command[i + 3] == 'p')) {
			return 1;
		}
		else if(command[i] == 'l' && command[i + 1] == 'd'){
			return 2;
		}
//	}
	return 0;
}
void printcmd(int op){
	if (op == 1) {
		myputc('h');
		myputc('e');
		myputc('l');
		myputc('p');
		myputc('_');
		myputc('c');
		myputc('m');
		myputc('d');
		myputc('!');
		enter();
		myputc('Y');
		myputc('o');
		myputc('u');
		myputc(' ');
		myputc('c');
		myputc('a');
		myputc('n');
		myputc(' ');
		myputc('t');
		myputc('y');
		myputc('p');
		myputc('e');
		myputc(' ');
		myputc('l');
		myputc('d');
	}
	else if(op == 2){
		myputc('l');
		myputc('d');
		myputc('_');
		myputc('c');
		myputc('m');
		myputc('d');
		myputc('!');
	}
}
int readcmd()
{
	char ch = 0, len = 0, cursor = 0;
	char x, i;
	for (i = 0; i < 60; i++)
		command[i] = 0;
	while (ch != enterkey && len < 60) {
		ch = mygetc();
		if (ch != enterkey) {
			if ((ch >= 'A' && ch <= 'Z')
				|| (ch >= 'a' && ch <= 'z')
				|| (ch >= '0' && ch <= '9')) {
				for (i = cursor; i < len; i++) {
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
			if (_sysscancode == sysscanleft && cursor > 0) {
				cursorleft();
				cursor = cursor - 1;
			}
			if (_sysscancode == sysscanright && cursor < len) {
				cursorright();
				cursor = cursor + 1;
			}
			if (_sysscancode == sysscandelete && cursor < len) {
				for (i = cursor; i < len; i++) {
					ch = command[i + 1];
					command[i] = ch;
					myputc(ch);
				}
				for (i = 0; i < len - cursor; i++)
					cursorleft();
				len = len - 1;
				command[len] = 0;
			}
			if (_sysscancode == sysscanbackspace && cursor > 0) {
				if (cursor == len) {
					cursorleft();
					myputc(' ');
				}
				else
					for (i = cursor; i < len; i++) {
						ch = command[i];
						command[i - 1] = ch;
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
	
	int flag = 0;
	if (len) flag = 1;
	command[len] = 0;
	len = 0;
	int op = 0;
	op = iscmd();
	if (op) {
		printcmd(op);
	}
	else {
		while (command[len] != 0) {
			ch = command[len];
			myputc(ch);
			len = len + 1;
		}
	}
	
	if(flag)enter();
	
	return 0;
}
