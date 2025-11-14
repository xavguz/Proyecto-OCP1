#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void num_casillas(int *num);
int calc_avg(int num);
void fill_arr(int num, int tesoros, int *p_arr);
int n_aleatorio(int min, int max);
void movimiento_jugador(int *jugador, int num, int *tablero);
void movimiento_maquina(int *maquina, int num, int *tablero);
int partida(int *jugador, int *maquina);
void robo(int *ganador, int *perdedor);
void mostrar_datos(int *pj, int dinero_o);

int main(){

	srand(time(NULL));

	int tablero[119];
	int num = 20; //numero de casillas en la partida
	int *p_num = &num;
	int tesoros; //numero de tesoros en la partida

	// arr[posicion, dinero_acumulado,n_tesoros,llego_a_la_meta]
	int jugador[] = {0,0,0,0};
	int maquina[] = {0,0,0,0};

	num_casillas(p_num);
	tesoros = calc_avg(num);
	fill_arr(num, tesoros, tablero);

	/* imprime tablero
	for (int i = 0; i < num; i++){
		printf("%d.\t%d\n",i + 1 ,tablero[i]);

	}
	*/

	while (partida(jugador, maquina)){
		if (!jugador[3]){
			printf("TURNO: Jugador\n");
			movimiento_jugador(jugador, num, tablero);
		}

		if (!maquina[3] && jugador[2] != 3){
			printf("TURNO: Maquina\n");
			movimiento_maquina(maquina, num, tablero);
		}
	}

	printf("La partida termino\n");

	if (maquina[2] == 3) {
		robo(maquina,jugador);
		printf("GANADOR: MAQUINA\tDinero acumulado: %d\tTesoros: %d\n",maquina[1], maquina[2]);
		printf("PERDEDOR: JUGADOR\tDinero acumulado: %d\tTesoros: %d\n",jugador[1], jugador[2]);
	}

	else if (jugador[2] == 3){
                robo(jugador,maquina);
                printf("GANADOR: JUGADOR\tDinero acumulado: %d\tTesoros: %d\n",jugador[1],jugador[2]);
                printf("PERDEDOR: MAQUINA\tDinero acumulado: %d\tTesoros: %d\n",maquina[1],maquina[2]);
        }

	else if (maquina[1] > jugador[1]){
		robo(maquina, jugador);
		printf("GANADOR: MAQUINA\tDinero acumulado: %d\tTesoros: %d\n",maquina[1],maquina[2]);
		printf("PERDEDOR: JUGADOR\tDinero acumulado: %d\tTesoros: %d\n",jugador[1], jugador[2]);
	}

	else if (maquina[1] < jugador[1]){
		robo(jugador,maquina);
		printf("GANADOR: JUGADOR\tDinero acumulado: %d\tTesoros: %d\n",jugador[1],jugador[2]);
		printf("PERDEDOR: MAQUINA\tDinero acumulado: %d\tTesoros: %d\n",maquina[1],maquina[2]);
	}

	return 0;
}

void num_casillas(int *num){
	int n_valido = 0;

	while (!n_valido){
		printf("Ingrese el numero de casillas: ");
	        scanf("%d", num);

		if ( !(*num < 20 || *num > 120 )){
			n_valido = 1;
		}
		else {
			printf("Ingresar numero valido (20 - 120)\n");
		}
	}
}


int calc_avg(int num){
	int avg = (30*num)/100;
	printf("El numero de tesoros en la partida (%d)\n\n",avg);

	return avg;
}

//Los tesoros estan representados por el 1
void fill_arr(int num, int tesoros, int *p_arr){
	int tesoros_arr = 0;

	for(int i = 0; i < num; i++){

		int tesoros_faltantes = tesoros - tesoros_arr;
		int casillas_faltantes = num -i;

		if (tesoros_faltantes == casillas_faltantes){
			p_arr[i] = 1;
			tesoros_arr++;
		}

		else if (n_aleatorio(1,3) == 3 && tesoros_arr < tesoros){
			p_arr[i] = 1;
			tesoros_arr++;
		}

		else{
			int money = n_aleatorio(10, 100);
			p_arr[i] = money;
		}
	}
}

int n_aleatorio(int min, int max){
	return rand() % (max - min + 1) + min;
}

void movimiento_jugador(int *jugador, int num, int *tablero){
	int pasos;
	int mov_valido = 0;

	while (!mov_valido){
		printf("Ingrese el numero de casillas a mover (1 - 6): ");
		scanf("%d", &pasos);

		if (pasos <= 0 || pasos > 6){
			printf("Valor incorrecto!\n");
		}

		else if (jugador[0] + pasos > num){
			printf("No te puedes mover ese numero de casillas!\n");
		}

		else {
			mov_valido = 1;
		}
	}

	jugador[0] += pasos;

	int pos_actual = jugador[0];
	int dinero_obtenido;


	if (tablero[pos_actual - 1] == 1){
		printf("Encontro tesoro +1!\n");
		jugador[2]++;
		dinero_obtenido = 0;
	}

	else {
                dinero_obtenido = tablero[pos_actual -1];
        }


	if (pos_actual == num){
		jugador[3] = 1;
		printf("El jugador se movio %d casillas, llego a la meta!\n",pasos);
	}

	else {
		printf("El jugador se movio %d casillas, su posicion actual es %d\n\n", pasos, pos_actual);
	}

	jugador[1] += dinero_obtenido;
	/*
	printf("Tesoros: %d\n", jugador[2]);
	printf("Dinero obtenido: %d\n", dinero_obtenido);
	printf("Dinero acumulado: %d\n\n", jugador[1]);
	*/
	mostrar_datos(jugador, dinero_obtenido);
}

void movimiento_maquina(int *maquina, int num, int *tablero){
	int pasos;
        int mov_valido = 0;

        while (!mov_valido){
		pasos = n_aleatorio(1,6);

                if (maquina[0] + pasos <= num){
                        mov_valido = 1;
                }
        }

	maquina[0] += pasos;

	int pos_actual = maquina[0];
        int dinero_obtenido;

	if(tablero[pos_actual - 1] == 1){
                printf("Encontro tesoro +1!\n");
		dinero_obtenido = 0;
                maquina[2]++;
        }

	else {
		dinero_obtenido = tablero[pos_actual -1];
	}

	if (pos_actual == num){
                maquina[3] = 1;
                printf("La maquina se movio %d casillas, llego a la meta!\n",pasos);
        }

        else {
                printf("La maquina se movio %d casillas, su posicion actual es %d\n\n", pasos, pos_actual);
        }

        maquina[1] += dinero_obtenido;

	/*
        printf("Tesoros: %d\n", maquina[2]);
        printf("Dinero obtenido: %d\n", dinero_obtenido);
        printf("Dinero acumulado: %d\n\n", maquina[1]);
	*/

	mostrar_datos(maquina, dinero_obtenido);
}

int partida(int *jugador, int *maquina){
	int bool1 = jugador[2] < 3 && maquina[2] < 3;
        int bool2 = jugador[3] == 1 && maquina[3] == 1;

	return bool1 && !(bool2);
}

void robo(int *ganador, int *perdedor){

	int monto_robado = perdedor[1];
	perdedor[1] = 0;

	ganador[1] += monto_robado;

	printf("Se robo %d dinero\n",monto_robado);
}

void mostrar_datos(int *pj, int dinero_o){
	printf("Dinero obtenido: %d\tDinero acumulado: %d\tTesoros: %d\n\n",dinero_o, pj[1], pj[2]);

}
