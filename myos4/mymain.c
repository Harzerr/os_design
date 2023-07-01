__asm__(".code16gcc\n");
extern int puts(char *str);
char * str = "Hello world from C Language! -myos.c";
int main()
{
	puts(str);
	for(;;);
}