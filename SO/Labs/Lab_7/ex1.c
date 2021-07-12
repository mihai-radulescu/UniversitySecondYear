#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

#define MAX_RESOURCES 10 

//Resurse.
int max_res, avb_res;

pthread_mutex_t mutex;

//Functie care creste numarul de resurse disponibile.
int increase_count(int count) {
   //Inchid mutex
   int err = pthread_mutex_lock(&mutex);

   //Verific daca exista erori.
    if(avb_res + count < 0 || avb_res - count > max_res) 
        err = -1;
  
   //Creste numarul de resurse disponibile. 
   if (err != -1) {
       printf("Released %d resources. %d remaining\n", avb_res, avb_res + count);
       
       avb_res += count;
   }
   else {
       printf("Maximum number of resources exceeded from %d to %d!\n",  avb_res, avb_res + count);
   }

   fflush(stdout);

   //Eliberez mutex.
   err = pthread_mutex_unlock(&mutex);

   return err;
}

//Functie care scadenumarul de resurse disponibile.
int decrease_count(int count) {
    //Inchid mutex
     int err = pthread_mutex_lock(&mutex);
     
     //Verific daca exista erori.
     if(avb_res - count < 0 || avb_res + count > max_res) 
        err = -1;
   
    //Scade numarul de resurse disponibile. 
   if (err != -1) {
       printf("Got %d resources. %d remaining\n", avb_res, avb_res - count);
       
       avb_res -= count;
   }
   else {
       printf("Not enough resources available. From %d to %d!\n",  avb_res, avb_res - count);
   }
   
    fflush(stdout);
   
   //Eliberez mutex.
   err = pthread_mutex_unlock(&mutex);

   return err;
}

//Solicitare resurse.
void* fake_request(void* q) {
   int count = *((int*)q);
  
   if (count > 0)
       increase_count(count);
   else
       decrease_count(-count);
   
   free(q);
   
   return NULL;
}

//Test.
void Test() {
   printf("\n");

   max_res = MAX_RESOURCES;

   printf("MAX_RESOURCES: %d\n", max_res);
  
   pthread_t* threads = malloc(sizeof(threads) * 10);
   
   for (int i = 0; i < 10; i++) {
       
       int* add = malloc(sizeof add);
       
       *add = rand() % 10 - 5;
       
       pthread_create(threads + i, NULL, fake_request, add);
   }

   for (int i = 0; i < 10; i++)
       pthread_join(threads[i], NULL);
   
   free(threads);
}

int main() {
   pthread_mutex_init(&mutex, NULL);

   Test();

   return 0;
}