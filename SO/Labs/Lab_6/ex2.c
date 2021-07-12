#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

#define MAX_DIM 1000

//Matricele sunt retinute in sirul matrix.
//matrix[0] si matrix[1] reprezinta matricele initiale.
//matrix[2] reprezinta rezultatul inmultirii.
int matrix[3][MAX_DIM][MAX_DIM];

pthread_t threads[MAX_DIM][MAX_DIM];

int N, M, K;

//Functie care calculeaza produsul.
void* matrixProd(void* v_args) {

    //Convertesc pointer la int.
    int* args = v_args;

   //Preiau valorile din args.
   int x = args[0], y = args[1];


   //Calculez valoarea fiecarui element din matrix[2].
   int rez = 0;

   for (int i = 0; i < M; i++)
       rez += matrix[0][x][i] * matrix[1][i][y];

   //Adaug valoare in matrix[2].
   matrix[2][x][y] = rez;

   free(v_args);
}

//Fnctie care citeste o marice.
//Prin variabila c specific in ce matrice se introduc valorile citite.
int matrixRead(int c, int* R, int* C) {

    printf("Introduceti numarul de linii: \n-> ");
    scanf("%d", R);
    printf("Introduceti numarul de coloane : \n-> ");
    scanf("%d", C);
    printf("Intorduceti valorile:\n");

    for (int i = 0; i < *R; i++) {
       printf("-> ");

       for (int j = 0; j < *C; j++)
           scanf("%d", matrix[c][i] + j);
        }
   return 0;
}


int main() {
    //Citire
   int n1, n2, m1, m2;
   
   if (matrixRead(0, &n1, &m1) || matrixRead(1, &n2, &m2)) {
       printf("Input-ul nu s-a putut citi!\n");

       return -1;       
   }

   //Verific daca dimensiunile sunt compatibile
   if (m1 != n2) {
       printf("Dimensiunile nu sunt compatibile!\n");

       return -1;
   }

   N = n1, M = m1, K = m2;

   //Lansez threadurile.
   for (int i = 0; i < N; i++) {
       for (int j = 0; j < K; j++) {
            //Creez lista argumentelor.
            int* args = malloc(2 * sizeof args);

            args[0] = i, args[1] = j;

            //Apelez threadul.
            if (pthread_create(threads[i] + j, NULL, matrixProd, args)) {
               perror(NULL);

               return errno;
           }
       }
   }

    //Imbin thread-urile
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
           // Prind threadul.
            if (pthread_join(threads[i][j], NULL)) {
               perror(NULL);

               return errno;
            }
        }
    }

   //Afisare rezulat
   printf("Produsul este:\n");

   for (int i = 0; i < N; i++) {
       for (int j = 0; j < K; j++)
           printf(" %d", matrix[2][i][j]);

       printf("\n");
   }

   return 0;
}