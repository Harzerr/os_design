__asm__(".code16gcc\n");
extern int puts(char *str);
char * str = "Hello world from C Language! -myos.c"; 
int _mymain()
{
	puts(str);
	for(;;);
}
