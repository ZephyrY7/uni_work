#include <string.h> 		//string functions
#include <stdlib.h>			//macro
#include <ctype.h>			//check input data type

int menu(); 				//main menu
int assign_num(); 			//function to assign new number
int search_up_num();		//function to choose what to search
char r_exist(); 			//function to show when the input data already exist in txt file
int upd();					//update exisiting data with new phone number 
int remov();				//delete specific record from txt file
int show_all();				//show a list of all records
int quit();					//function to quit
char search();				// function to search records / check if there is exisiting record
int spacing();				//spacing to let the interface looks clearly when printing all records

#include "Show all.h"

int menu(){
	char function_c[3];																//user choice of function int
	do{
		printf("\n1. Assign a new record.\n2. Search for update or delete an existing record.\n3. Show a list of all stored record.\n4. Exit the program.\n5. Clear the screen.\n");
		printf("\nPlease enter the respective number for the function:");
		fgets(function_c,3,stdin);
		if(function_c[1]!='\n'){
			strcpy(function_c,"0");
		}
		fflush(stdin);
		switch(function_c[0]){ 													//run codes for recpective functions.
			case '1':
				assign_num();break;
			case '2':
				search_up_num();break;
			case '3':
				show_all();break;
			case '4':
				quit();break;
			case '5':
				system("cls");
				printf("Returning to main menu....\n");
				menu();
				break;
			default:
				printf("\nInvalid input..Returning to Main Menu...\n");
		}
	}while(1); 																	// always looping when the option is not 1,2,3&4
}

int menu_back(){	
	printf("\nReturning to main menu...\n");
	return menu();
}																				//function to call back main menu

int quit(){
	system("cls");
	printf("\nProgram Exited\n");
	exit(0);
}																				//function to exit the program

char r_exist(char name_s1[60],char id_s1[15],char phone_s1[30],char dep_s1[40]){	//All the searched data will be passed into the function
	printf("\n**Record exist!**\n");
	printf("Name:%sID:%sPhone Number:%sDepartment:%s\n",name_s1,id_s1,phone_s1,dep_s1);
	return 0;
}																					//function to show the user there is an existing record of the data they are trying to key in

int assign_num(){		//add new record
	printf("\n*Assign new number.*\n");
	size_t templen,i;
	int line_s1=0,name_check,phone_check,id_check;							//int for user option and flag variable when the input is not applicable 
	char Name[55],ID[10],Phone[25],Depart[20],name_s[60],id_s[15],phone_s[30],dep_s[40],dep_c[3],opt1[3];	//array to store user input and data return by search function
	FILE *f;	
	do{																						//loop for name input
		name_check=0;																		//flag variable set to 0 on every loop
		printf("Enter the Name (Maximum 50 characters, numbers is not allowed):");
		fgets(Name,55,stdin);
		fflush(stdin);
		templen=strlen(Name);
		if(Name[0]=='\n'){																	//check for blank input
			printf("\n**Do not enter blank data**\n\n");
			name_check=1;continue;
		}
		if(templen>51){																		//check for length of name
			name_check=1;
		}
		for(i=0;i<templen;i++){																//check for input name whether it contain numbers
			if(Name[i]=='\n'){
				break;
			}
			if(isdigit(Name[i])){
				name_check=1;
			}
		}
		if(name_check==1){																	//print the warning when user input is not applicable 
			printf("\n**Maximum 50 characters, numbers is not allowed**\n\n");
		}else{																				//if input is usable, check for exisiting data to see if there is duplication
			strupr(Name);
			search(Name,&name_s,&id_s,&phone_s,&dep_s,&line_s1);
			if(strcmp(Name,name_s)==0){
				r_exist(name_s,id_s,phone_s,dep_s);
				name_check=1;
			}
		}	
	}while(name_check==1);																	//prompt the user to input the name again because data is not applicable
	do{
		id_check=0;																			//flag variable set to 0
		printf("Enter ID (Eg. AB0023):");	//input ID
		fgets(ID,10,stdin);
		fflush(stdin);
		if(!isalpha(ID[0])||!isalpha(ID[1])||!isdigit(ID[2])||!isdigit(ID[3])||!isdigit(ID[4])||!isdigit(ID[5])||ID[6]!='\n'){
			printf("\nPlease enter the corrrect format! (Eg. AB0023)**\n\n");
			id_check=1;continue;
		}																					//check whether the input ID is following the format [Alphabet,alphabet,number,number,number,number]
		if(id_check==0){																	//check existing data to see if there is duplication
			strupr(ID);
			search(ID,&name_s,&id_s,&phone_s,&dep_s,&line_s1);
			if(strcmp(id_s,ID)==0){
				r_exist(name_s,id_s,phone_s,dep_s);
				id_check=1;
			}	
		}
	}while(id_check==1);																	//prompt user to input ID again if input is not applicable
	do{
		phone_check=0;
		printf("Enter Phone(Maximum 20 characters, only numbers are allowed):");			//input phone numbers
		fgets(Phone,25,stdin);
		fflush(stdin);
		templen=strlen(Phone);
		for(i=0;i<templen;i++){																//check input is it all numbers
			if(Phone[i]=='\n'){
				break;
			}
			if(!isdigit(Phone[i])){
				phone_check=1;
			}
		}
		if(Phone[0]=='\n'||templen>21){
			phone_check=1;
		}
		if(phone_check==1){
			printf("\n**Maximum 20 characters, only numbers are allowed**\n\n");
		}else{
			search(Phone,&name_s,&id_s,&phone_s,&dep_s,&line_s1);
			if(strcmp(Phone,phone_s)==0){
				r_exist(name_s,id_s,phone_s,dep_s);
				phone_check=1;
			}	
		}
	}while(phone_check==1);																	//prompt user to input phone num. again if input is not applicable
	do{
		printf("Choose the department of this employee:\n1)Administrator\n2)Finance\n3)Human Resource\n4)Marketing\n5)Student Services\n6)IT\n7)Lecturer\n8)Others\nOptions:");	//Department choices
		fgets(dep_c,3,stdin);
		if(dep_c[1]!='\n'){
			strcpy(dep_c,"0");
		}
		fflush(stdin);
		switch(dep_c[0]){
			case '1':
				strcpy(Depart,"Administration");break;
			case '2':
				strcpy(Depart,"Finance");break;
			case '3':
				strcpy(Depart,"Human Resource");break;
			case '4':
				strcpy(Depart,"Marketing");break;
			case '5':
				strcpy(Depart,"Student Services");break;
			case '6':
				strcpy(Depart,"IT");break;
			case '7':
				strcpy(Depart,"Lecturer");break;
			case '8':
				strcpy(Depart,"Others");break;
			default:
				printf("\nInvalid input, please try again.\n\n");
		}
	}while(dep_c[0]!='1'&&dep_c[0]!='2'&&dep_c[0]!='3'&&dep_c[0]!='4'&&dep_c[0]!='5'&&dep_c[0]!='6'&&dep_c[0]!='7'&&dep_c[0]!='8');	//department choices looping
	do{
		printf("\nNew employees data:\nName:%sID:%sNumber:%sDepartment:%s\n",Name,ID,Phone,Depart);	//print out the data of new data to let the user check 
		printf("\n1)Save the data.\n2)Discard the data and return to main menu.\n");
		printf("Option:");
		fgets(opt1,3,stdin);
		if(opt1[1]!='\n'){
			strcpy(opt1,"0");
		}
		fflush(stdin);
		switch(opt1[0]){
			case '1':
				f=fopen("tel.txt","a+");
				fprintf(f,"\n%s%s%s%s\n",Name,ID,Phone,Depart);								//save the record into txt file
				fclose(f);
				system("cls");
				printf("New data saved...\n");
				return 0;
				break;
			case '2':
				system("cls");
				return 0;break;
			default:
				printf("\nInvalid input, please try again.\n");
		}
	}while(1);
}

int search_up_num(){															//function to search records from txt file
	size_t templen;
	char search_k[65],name_s[60],id_s[15],phone_s[30],dep_s[40],opt1[3];
	int line_s1=0,input_check=0;
	printf("\n*Search existing records.*\n");
	do{
		input_check=0,line_s1=0;	
		printf("Enter employee Name / ID / Phone to search existing records (Max 60 characters, blank input to return main menu):\n");
		fgets(search_k,65,stdin);
		fflush(stdin);
		templen=strlen(search_k);
		if(search_k[0]=='\n'){													//if blank input then return to main menu
			system("cls");
			menu_back();
		}
		if(templen>61){
			printf("\n**Maximum 60 characters**\n");
			input_check=1;
		}
		if(input_check==0){
			strupr(search_k);
			search(search_k,&name_s,&id_s,&phone_s,&dep_s,&line_s1);
			if(line_s1!=0){
				r_exist(name_s,id_s,phone_s,dep_s);
			}else{
				printf("\n**No result found**\n");
				input_check=1;
			}
		}																		//input key check if it is applicable
	}while(input_check==1);
	printf("**Data searched**\n");
	do{																			//prompt the user to choose what to do after searched the record
		printf("\n1)Update phone number\n2)Delete\n3)Return Main Menu\n4)Exit the program\n");
		printf("\nOptions:");
		fgets(opt1,3,stdin);
		if(opt1[1]!='\n'){
			strcpy(opt1,"0");
		}
		fflush(stdin);
		switch(opt1[0]){
			case '1':
				upd(line_s1,phone_s);
				printf("\nReturning to main menu....");
				return 0;
				break;
			case '2':
				remov(line_s1);
				printf("\nReturning to main menu....\n");
				return 0;
				break;
			case '3':
				system("cls");
				printf("\nReturning to main menu....\n");
				return 0;break;
			case '4':
				quit();break;
			default:
				printf("\nInvalid input. Please try again.\n");
		}
	}while(1);
}

int upd(int line,char phone_ori[30]){										//original phone record and line of record is passed to update function
	printf("%d",line);
	int line_check=-1,phone_check=0,i,line_s1=0;
	FILE *f,*ftemp;
	char Phone_new[25],temp[2],name_s[60],id_s[15],phone_s[30],dep_s[40];
	size_t templen=0;
	do{
		phone_check=0;
		printf("\nEnter new PhoneNum.(Maximum 20 characters, only numbers are allowed):");	//input 	phone numbers
		fgets(Phone_new,25,stdin);
		fflush(stdin);
		templen=strlen(Phone_new);
		for(i=0;i<templen;i++){
			if(Phone_new[i]=='\n'){
				break;
			}
			if(!isdigit(Phone_new[i])){
				phone_check=1;
			}
		}
		if(Phone_new[0]=='\n'||templen>21){
			phone_check=1;
		}
		if(phone_check==1){
			printf("\n**Maximum 20 characters, only numbers are allowed**\n");continue;
		}
		if(strcmp(Phone_new,phone_ori)==0){
			printf("\n**Do not enter the same number**\n");
			phone_check=1;continue;
		}
		search(Phone_new,&name_s,&id_s,&phone_s,&dep_s,&line_s1);
		if(strcmp(Phone_new,phone_s)==0){
			r_exist(name_s,id_s,phone_s,dep_s);
			phone_check=1;continue;
		}
		if(phone_check!=1){
			printf("\nNew Phone Number:%s",Phone_new);
			f=fopen("tel.txt","r");
			ftemp=fopen("updtemp.txt","w+");
			while(fgets(temp,2,f)!=NULL){
				fgets(name_s,60,f);
				fgets(id_s,15,f);
				fgets(phone_s,30,f);
				fgets(dep_s,40,f);
				line_check+=5;
				if(line==line_check-3){
					strcpy(phone_s,Phone_new);											//replace the old phone record to new number
				}
				fprintf(ftemp,"%s%s%s%s%s",temp,name_s,id_s,phone_s,dep_s);				//copy the data into new txt
			}
			fclose(f);
			fclose(ftemp);
			remove("tel.txt");
			rename("updtemp.txt","tel.txt");
			printf("\n**Record updated...**\n");										//swap the txt and save the records
		}
	}while(phone_check==1);
	return 0;
}

int remov(int line){
	int line_check=-1;
	FILE *f,*ftemp;
	char temp[2],name_s[60],id_s[15],phone_s[30],dep_s[40];
	f=fopen("tel.txt","r");
	ftemp=fopen("revtemp.txt","w+");
	while(fgets(temp,2,f)!=NULL){
		fgets(name_s,60,f);
		fgets(id_s,15,f);
		fgets(phone_s,30,f);
		fgets(dep_s,40,f);
		line_check+=5;
		if(line==line_check-3){
			strcpy(temp,"\0");
			strcpy(name_s,"\0");
			strcpy(id_s,"\0");
			strcpy(phone_s,"\0");
			strcpy(dep_s,"\0");
		}																				//replace all the data to blank '\0' as removing the records
		fprintf(ftemp,"%s%s%s%s%s",temp,name_s,id_s,phone_s,dep_s);
	}
	fclose(f);
	fclose(ftemp);
	remove("tel.txt");
	rename("revtemp.txt","tel.txt");
	system("cls");
	printf("\n**Record deleted**\n");
	return 0;
}

char search(char search_in[60],char n_search[60],char id_search[15],char p_search[30],char d_search[40],int *line_s){			
	char nam_s_tmp[60],id_s_tmp[15],phon_s_tmp[30],dep_s_tmp[40],search[2];										//temp array to store data search
	FILE *f;
	size_t templen;
	int line=-1;
	f=fopen("tel.txt","r");
	while(fgets(search,2,f)!=NULL){
		fgets(nam_s_tmp,60,f);
		fgets(id_s_tmp,15,f);
		fgets(phon_s_tmp,30,f);
		fgets(dep_s_tmp,40,f);
		line+=5;
		if(strcmp(id_s_tmp,search_in)==0||strcmp(nam_s_tmp,search_in)==0||strcmp(phon_s_tmp,search_in)==0){		//search the data by comparing string 
			strcpy(n_search,nam_s_tmp);
			strcpy(id_search,id_s_tmp);
			strcpy(p_search,phon_s_tmp);
			strcpy(d_search,dep_s_tmp);
			*line_s=line-3;
			break;
		}
	}
	fclose(f);
	return 0;
}													////search key is passed in this function and all the search data is return by pointer


