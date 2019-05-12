#include <stdio.h>
#include "teaclib.h"

int limit, number, counter;

int prime(int n) {
	int i;

	int result, isPrime;

	if(n < 0){
	result = prime(-n);

	}else{
	if(n < 2){
	result = 0;

	}else{
	if(n == 2){
	result = 1;

	}else{
	if(n % 2 == 0){
	result = 0;

	}else{
	i = 3;

	isPrime = 1;

	while(isPrime && (i < n / 2)){
	isPrime = n % i != 0;

	i = i + 2;

	}

	result = isPrime;
	}
	}
	}
	}

	return result;

};


int main(){
	limit = readInt();

	counter = 0;

	number = 2;

	while(number <= limit){
		if(prime(number)){
	counter = counter + 1;

	writeInt(number);


	writeString(" ");

	}

	number = number + 1;

	}

	writeString("\n");


	writeInt(counter);


	return 0;
}

