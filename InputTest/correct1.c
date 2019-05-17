#include <stdio.h>
#include "teaclib.h"

double tester(int i, int m) {
	int table[4];

	table[0] = (((1 + 1) - 5 + (7 % 7)) * 2);

	table[1] = table[0] * 2;

	table[2] = table[0] * table[1];

	table[3] = 3;

	while(i != 4){
	writeString("TABLE[");


	writeInt(i);


	writeString("]:");


	writeInt(table[i]);


	writeString("\n");


	i = i + 1;

	}

	return 2.3;

};


int main(){
	int i = 1, table[5];

	const int k = 2;

	if((k % 3 == 0)){
	writeString("FAIL");


	}else{
	i = 0;

	tester(i , i);

	}

	writeString("Success\n");

}

