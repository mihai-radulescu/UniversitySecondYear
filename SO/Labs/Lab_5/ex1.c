#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <sys/wait.h>

//Convertesc parametrul in int.
//Verific sa fie format doar din cifre. 
int ConvToInt(char *arr) {
   int ans = 0;
   int l = strlen(arr);

   if (l == 0)
          return -1;

   for (int i = 0; i < l; i++) 
   {
       if (arr[i] > '9' || arr[i] < '0')
           return -1;

       ans = 10 * ans + arr[i] - '0';
   }

   return ans;
}

int main(int argc, char* args[]) {

   //Nu a fost dat nici un argument.
   if (argc == 1) {
       printf("Error: Found no arguments!\n");
       return 0;
   }

   //Numesc memoria partajata.
   const char shm_name[] = "collaz_shared_memory";

   //Deschid memoria partajata.
   int shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

   //Nu pot deschide.
   if (shm_fd < 0) {
       perror(NULL);
       return errno;
   }

   //Aloc memorie pentru copil.
   int CHILD_SIZE = getpagesize();

   int shm_size = CHILD_SIZE * (argc - 1);


   //Nu pot modifica dimensiune memoriei partajate.
   if (ftruncate(shm_fd, shm_size) == -1) {
       perror(NULL);
       shm_unlink(shm_name);
       return errno;
   }

    printf("\n");

   //Afisez parintele.
   printf("Starting parent %d\n\n", getpid());
   fflush(stdout);


  //Nr retine numarul corespunzator procesului.
   int nr = 0;

   //Aplelez fork().
   for (int i = 1; i < argc; i++) {
       int pid = fork();

       if (pid < 0) {
           printf("Error while forking!\n");
           perror(NULL);
           return errno;
       }

       if (pid == 0) {
           //Afisez procesul copil.
           nr = i;
           printf("Done Parent %d Child %d\n", getppid(), getpid());
           fflush(stdout);

           break;
       }
   }

   if (nr) {
       //Deschid memoria partajata.
       int* shm_ptr = mmap(0, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, (nr - 1) * CHILD_SIZE);

       if (shm_ptr == MAP_FAILED) {
           perror(NULL);
           printf("Unable to open shared memory!\n");
           fflush(stdout);

           return errno;
       }

       int val = ConvToInt(args[nr]);

       //Trec peste daca un argument este invalid.
       if (val == -1) {
           shm_ptr[0] = -1, shm_ptr[1] = 0;
           munmap(shm_ptr, CHILD_SIZE);

           return -1;
       }

       //Retin pe poz 0 valoarea si pe poz 1 dimensiunea. 
       shm_ptr[0] = val;
       shm_ptr[1] = 0;

       for (int i = 2; i < CHILD_SIZE / 4 && val; i++) {
           shm_ptr[i] = val;
           shm_ptr[1]++;

           if ((val % 2) && val != 1)
               val = 3 * val + 1;

           val = val / 2;
       }

       munmap(shm_ptr, CHILD_SIZE);

       return 0;
   }

   //Astept dupa procesele copil. 
   for (int i = 1; i < argc; i++) {
       int process_id, ret_code;

       process_id = wait(&ret_code);

       fflush(stdout);
   }


   //Deschid memoria partajata.
   void* shm_ptr = mmap(0, shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);

   if (shm_ptr == MAP_FAILED) {
       perror(NULL);
       printf("Unable to open shared memory!\n");
       fflush(stdout);

       return errno;
   }

   printf("\n");
   
   for (int i = 1; i < argc; i++) {
       //Afisez rezultatele.
       int* vec = shm_ptr + CHILD_SIZE * (i - 1);

       printf("%d: ", vec[0]);

       for (int j = 0; j < vec[1]; j++)
           printf("%d ", vec[j + 2]);

       printf("\n");
       
       fflush(stdout);
   }

   //Eliberez memoria

   munmap(shm_ptr, shm_size);

   shm_unlink(shm_name);

   return 0;
}