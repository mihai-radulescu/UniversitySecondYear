#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
   int parent_pid = getpid();
   int child_pid = fork();

    if (child_pid < 0) {
       // Error
       printf("Error while forking: %d\n", child_pid);
       return -1;
   }

   if (child_pid == 0) {
       //Se executa codul pt copil
       char *argv[] = { "ls", NULL };
       execve("/bin/ls", argv, NULL);
      
       //Nu mai apar error-i
       perror(NULL);
   }
   else {
       //Printez codul pt copil si parinte
       printf("My PID = %d, Child PID = %d\n", parent_pid, child_pid);
       fflush(stdout);
   }
   return 0;
}
