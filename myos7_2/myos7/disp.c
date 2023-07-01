#include "disp.h"
int printdata(unsigned short int n)
{
	char ch[5], count = 0, i;
	while(n != 0){
		ch[4-count] = (n % 10) + 0x30;
		n = n / 10;
		count = count + 1;
	}
	for (i = count; i > 0; i--)
		myputc(ch[5-i]);
	return 0;
}			