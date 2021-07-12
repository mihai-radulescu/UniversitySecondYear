#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

//Convertesc parametrul in int
//Verific sa fie format doar din cifre 
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

//Printez numerele pentru valoarea din variabila value
int PrintSet(int value) {
   printf("%d: ", value);

   while (value != 1) {
           printf("%d ", value);

           if (value % 2) {
               //Verific sa nu existe overflow
               int x = 3 * value + 1;

               if (value != (x - 1) / 3) {
                   printf("Overflow!\n");
                   return -1;
               }

               value = 3 * value + 1;
           }
           else
               value = value / 2;
       }

       printf("1\n");

       return 0;
   }

int main(int argc, char *argv[]) {

   //Numar de apelari
   int nr = 0;

   for (int i = 1; i < argc; i++) {
       int value = ConvToInt(argv[i]);

       if (value == -1) {
           printf("Invalid number entered!\n");
           return -1;
       }

       int child_pid = fork();

       if (child_pid < 0) {
           printf("Error while trying to fork: %d!\n", child_pid);
           return -1;
       }

       if (child_pid == 0) {
           int code = PrintSet(value);

           if (code != 0) {
               printf("Process %d finished with an error!\n", getpid());
               return code;
           }

           printf("Process %d finished\n", getpid());

           return 0;      
       }
       else
           nr++;
   }

   while (nr--) {
        int process_id, code;

       process_id = wait(&code);

       if (code == 0)
           printf("Done Parent %d, Child %d\n", getppid(), getpid());
       else
           printf("Error at Process %d returned to %d with status %d\n", process_id, getpid(), code);

       fflush(stdout);
   }

   return 0;
}


