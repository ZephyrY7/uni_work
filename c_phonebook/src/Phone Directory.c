#include <stdio.h>			//standard input output
#include "function.h"

int main(){
	FILE *f;
	f=fopen("tel.txt","a+"); //file is checked/created everytime when the program launched
	fclose(f);
	printf("*Welcome to Phone Directory System!*\n");
	menu();
}

