

//struct to sort the data department wise
struct admin{
	char name1[60],id1[15],phone1[30];
};
struct finance{
	char name2[60],id2[15],phone2[30];
};
struct hr{
	char name3[60],id3[15],phone3[30];
};
struct marketing{
	char name4[60],id4[15],phone4[30];
};
struct students{
	char name5[60],id5[15],phone5[30];
};
struct it{
	char name6[60],id6[15],phone6[30];
};
struct lec{
	char name7[60],id7[15],phone7[30];
};
struct oth{
	char name8[60],id8[15],phone8[30];
};

int show_all(){
	int i;														//int to print UI
	register long c=0;											//long int to check the lines of txt
	register int c1=1,c2=1,c3=1,c4=1,c5=1,c6=1,c7=1,c8=1;		//int for storing the records into data struct
	size_t templen;
	char temp[20],name_s[60],id_s[15],phone_s[30],dep_s[40];	//data get from the txt should be store in those array
	FILE *f;
	f=fopen("tel.txt","r");
	system("cls");
	while(fgets(temp,20,f)!=NULL){
		c++;
	}c/=5;
	rewind(f);
	struct admin record1[c];
	struct finance record2[c];
	struct hr record3[c];
	struct marketing record4[c];
	struct students record5[c];
	struct it record6[c];
	struct lec record7[c];
	struct oth record8[c];
	printf("\n*Showing all stored records*\n");
	for(i=0;i<30;i++){
		printf("-");
	}
	if(fgets(temp,20,f)==NULL){
		printf("\nNo records stored!!\n");
	}rewind(f);
	while(fgets(temp,20,f)!=NULL){
		fgets(name_s,60,f);
		fgets(id_s,15,f);
		fgets(phone_s,30,f);
		fgets(dep_s,40,f);
		templen=strlen(name_s);
		name_s[--templen]='\0';
		templen=strlen(id_s);
		id_s[--templen]='\0';
		templen=strlen(phone_s);
		phone_s[--templen]='\0';
		if(strcmp(dep_s,"Administration\n")==0){
			strcpy(record1[c1].name1,name_s);
			strcpy(record1[c1].id1,id_s);
			strcpy(record1[c1].phone1,phone_s);
			c1++;continue;
		}
		if(strcmp(dep_s,"Finance\n")==0){
			strcpy(record2[c2].name2,name_s);
			strcpy(record2[c2].id2,id_s);
			strcpy(record2[c2].phone2,phone_s);
			c2++;continue;
		}
		if(strcmp(dep_s,"Human Resource\n")==0){
			strcpy(record3[c3].name3,name_s);
			strcpy(record3[c3].id3,id_s);
			strcpy(record3[c3].phone3,phone_s);
			c3++;continue;
		}
		if(strcmp(dep_s,"Marketing\n")==0){
			strcpy(record4[c4].name4,name_s);
			strcpy(record4[c4].id4,id_s);
			strcpy(record4[c4].phone4,phone_s);
			c4++;continue;
		}
		if(strcmp(dep_s,"Student Services\n")==0){
			strcpy(record5[c5].name5,name_s);
			strcpy(record5[c5].id5,id_s);
			strcpy(record5[c5].phone5,phone_s);
			c5++;continue;
		}
		if(strcmp(dep_s,"IT\n")==0){
			strcpy(record6[c6].name6,name_s);
			strcpy(record6[c6].id6,id_s);
			strcpy(record6[c6].phone6,phone_s);
			c6++;continue;
		}
		if(strcmp(dep_s,"Lecturer\n")==0){
			strcpy(record7[c7].name7,name_s);
			strcpy(record7[c7].id7,id_s);
			strcpy(record7[c7].phone7,phone_s);
			c7++;continue;
		}
		if(strcmp(dep_s,"Others\n")==0){
			strcpy(record8[c8].name8,name_s);
			strcpy(record8[c8].id8,id_s);
			strcpy(record8[c8].phone8,phone_s);
			c8++;continue;
		}
	}
	fclose(f);
	if(c1!=1){
		printf("\nAdministration:\nName                                               ID     PhoneNum.\n");
		for(c1-=1;c1>0;c1--){
			printf("%s",record1[c1].name1);
			spacing(strlen(record1[c1].name1));
			printf("%s ",record1[c1].id1);
			printf("%s\n",record1[c1].phone1);
		}
	}
	if(c2!=1){
		printf("\nFinance:\nName                                               ID     PhoneNum.\n");
		for(c2-=1;c2>0;c2--){
			printf("%s",record2[c2].name2);
			spacing(strlen(record2[c2].name2));
			printf("%s ",record2[c2].id2);
			printf("%s\n",record2[c2].phone2);
		}	
	}
	if(c3!=1){
		printf("\nHuman Resources:\nName                                               ID     PhoneNum.\n");
		for(c3-=1;c3>0;c3--){
			printf("%s",record3[c3].name3);
			spacing(strlen(record3[c3].name3));
			printf("%s ",record3[c3].id3);
			printf("%s\n",record3[c3].phone3);
		}
	}
	if(c4!=1){
		printf("\nMarketing:\nName                                               ID     PhoneNum.\n");
		for(c4-=1;c4>0;c4--){
			printf("%s",record4[c4].name4);
			spacing(strlen(record4[c4].name4));
			printf("%s ",record4[c4].id4);
			printf("%s\n",record4[c4].phone4);
		}
	}
	if(c5!=1){
		printf("\nStudent Services:\nName                                               ID     PhoneNum.\n");
		for(c5-=1;c5>0;c5--){
			printf("%s",record5[c5].name5);
			spacing(strlen(record5[c5].name5));
			printf("%s ",record5[c5].id5);
			printf("%s\n",record5[c5].phone5);
		}
	}
	if(c6!=1){
		printf("\nIT:\nName                                               ID     PhoneNum.\n");
		for(c6-=1;c6>0;c6--){
			printf("%s",record6[c6].name6);
			spacing(strlen(record6[c6].name6));
			printf("%s ",record6[c6].id6);
			printf("%s\n",record6[c6].phone6);
		}
	}
	if(c7!=1){
		printf("\nLecturers:\nName                                               ID     PhoneNum.\n");
		for(c7-=1;c7>0;c7--){
			printf("%s",record7[c7].name7);
			spacing(strlen(record7[c7].name7));
			printf("%s ",record7[c7].id7);
			printf("%s\n",record7[c7].phone7);
		}
	}
	if(c8!=1){
		printf("\nOthers:\nName                                               ID     PhoneNum.\n");
		for(c8-=1;c8>0;c8--){
			printf("%s",record8[c8].name8);
			spacing(strlen(record8[c8].name8));
			printf("%s ",record8[c8].id8);
			printf("%s\n",record8[c8].phone8);
		}
	}
	for(i=0;i<30;i++){
		printf("-");
	}
	printf("\n**All records shown**\n");
	printf("\nReturning to Main Menu....\n");
	return 0;
}

int spacing(int letter_in){			//spacing to let the interface looks cleaner and formatted
	int o=0;
	for(o=0;o<(51-letter_in);o++){
		printf(" ");
	}
}
