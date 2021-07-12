#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>
#include <semaphore.h>

sem_t sem;

pthread_mutex_t mutex;

int nr_processes;

void barrier_point() {
   //Numar procese contorizate.
   static int count = 0;

   //Inchid mutex.
   pthread_mutex_lock(&mutex);
   count++;

   //Daca au ajuns toate procesele, deblochez semaforul
   if (count == nr_processes) {
       pthread_mutex_unlock(&mutex);
       sem_post(&sem);

       return;
   }
  
   //Eliberez mutex.
   pthread_mutex_unlock(&mutex);

   //Astept la semafor.
   sem_wait(&sem);

   //Trec de semafor.
   sem_post(&sem);
}


//Functie executata de fiecare thread
void* tfun(void* v) {
   int *tid = (int*) v;

   printf("%d reached the barrier!\n", *tid);
   fflush(stdout);
  
   barrier_point();

   printf("%d passed the barrier!\n", *tid);
   fflush(stdout);

   free(tid);

   return NULL;
}

int main(int argc, char* args[]) {
   //Creez semaforul.
   sem_init(&sem, 0, 0);

   //Creeam mutex.
   pthread_mutex_init(&mutex, NULL);

   //Citesc numarul de procese. 
   printf("Cate procese doriti sa apelati?\n");
   scanf("%d", &nr_processes);

   pthread_t* threads = malloc(sizeof(threads) * nr_processes);
   for (int i = 0; i < nr_processes; i++) {
       int* arg = malloc(sizeof arg);
       *arg = i;

       pthread_create(threads + i, NULL, tfun, arg);
   }

   for (int i = 0; i < nr_processes; i++)
       pthread_join(threads[i], NULL);
   free(threads);

   return 0;
}
