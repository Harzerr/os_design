#include <stdio.h>
#include <stdlib.h> 
int main(int argc, char **argv)
{
	FILE *rfd, *wfd;
	char buf[256];
	int offset, bytes, totalbytes=0;
	if (argc != 4){
	fprintf(stderr, "Usage: %s source target offset\n", argv[0]);
	return -1;
	}
	if((rfd = fopen(argv[1], "rb"))==NULL){
	printf("Can't open the file %s! \n",argv[1]);
	return -1;
	}
	if((wfd = fopen(argv[2], "rb+"))==NULL){
	printf("Can't open the file %s! \n",argv[2]);
	return -1;
	}
	offset = atoi(argv[3]);
	offset = (offset - 1) * 512;
	fseek(wfd, offset, SEEK_SET);
	while((bytes = fread(buf, 1, 256, rfd)) > 0){
	fwrite(buf, 1, bytes, wfd);
	totalbytes += bytes;
	}
	fclose(rfd);
	fclose(wfd);
	printf("%d bytes copied from %s to %s\n",totalbytes, argv[1], argv[2]);
	return 0;
}