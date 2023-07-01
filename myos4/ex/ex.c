#include <stdio.h>
int myfunc1();
int myfunc2();
int main(int argc, char **argv)
{
	myfunc1();
	myfunc2();
	return 0;
}
int myfunc1()
{
	printf("First function!\n");
	return 0;
}
int myfunc2()
{
	printf("Second function!\n");
	return 0;
}
