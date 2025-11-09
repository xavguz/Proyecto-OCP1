#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void num_casillas(int *num);
int calc_avg(int num);
void fill_arr(int num, int tesoros, int *p_arr);

int main(){
	int tablero[119];
	int num = 20; //numero de casillas
	int *p_num = &num;
	int *p_arr = tablero;
	int tesoros;

	num_casillas(p_num);
	tesoros = calc_avg(num);
	fill_arr(num, tesoros, tablero);

	for (int i = 0; i < num; i++){
		printf("%d\n", tablero[i]);

	}

	printf("El promedio de recompensas es: %d\n", tesoros);
	return 0;
}

void num_casillas(int *num){
	printf("Ingrese el numero de casillas: ");
	scanf("%d", num);

	if (*num < 20 || *num > 120){
		num_casillas(num);
	}
}


int calc_avg(int num){
	int avg = (30*num)/100;
	return avg;
}

void fill_arr(int num, int tesoros, int *p_arr){
	srand(time(NULL));
	int tesoros_arr = 0;

	for(int i = 0; i < num; i++){;
		if (rand() % 3 + 1 == 3 && tesoros_arr < tesoros){
			p_arr[i] = 1;
			tesoros_arr++;
		}

		else{
			int money = rand() % 91 + 10;
			p_arr[i] = money;
		}
	}
}
