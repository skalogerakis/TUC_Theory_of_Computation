#include <stdio.h>
#include "teaclib.h"

int fib(int n) {
	int a = 0, b = 1, c, i;

	if(n == 0){
	return a;

	}else{
	}

	i = 2;

	while(i <= n){
	c = a + b;

	a = b;

	b = c;

	i = i + 1;

	}

	return b;

};


int main(){
	int n;

	writeString("GIVE INPUT TO CALCULATE THE N-TH FIBONNACI NUMBER\n");


	n = readInt();

	writeInt(fib(n));


	writeString("\n");


	return 0;
}

