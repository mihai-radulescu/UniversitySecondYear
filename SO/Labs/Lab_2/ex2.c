#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// Printez mesajul cu stdout
void PrintMessage(char* message)
{
   // lungimea mesajului
   int len = strlen(message);
   // Nr-ul caracterelor printate
   int written = 0, d;
  
   // Printez
   while ((d = write(1, message + written, len - written)) > 0) {
       written += d;
   }
}



int PrintError(char* message, int err_number)
{
   //Afisare mesaj error si cod
   write(2, message, strlen(message));
  
   char error_code[1000];
   int l = 0;
   while (err_number) {
       error_code[l++] = err_number % 10 + '0';
       err_number /= 10;
   }

   write(2, "Error code: ", strlen("Error code: "));
  
   while (l > 0) {
       l--;
       write(2, error_code + l, 1);
   }
  
   write(2, "\n\n", 2);
}


//Copiere fisier
int CopyFile(char* from, char* to)
{
   // Deschid fisierul de input in mod read_only
   int file_to_read = open(from, O_RDONLY);
   if (file_to_read == -1) {
       int error = errno;
       PrintMessage("Unable to open input file!\n");
       return errno;
   }



   // Creez si descid un fisier de output in mod read/write
   //Fisierul poate executa pentru a copia executabile
   int file_to_write = open(to, O_WRONLY | O_CREAT, S_IRWXU);
   if (file_to_write == -1) {
       int error = errno;
       PrintMessage("Unable to open input file!\n");
       return errno;
   }



   // Buffer pentru read/write.
   const int BUFF = 1024;
   char buffer[BUFF];



   int d;
   while ((d = read(file_to_read, buffer, BUFF)) > 0) {
       int written = 0, act;
       
       while ((act = write(file_to_write, buffer + written, d - written)) > 0)
           written += act;
      
        //Error cand scriu in fisierul de output
       if (act == -1) {
           int error = errno;
           PrintMessage("Unable to write in output file!\n");
           return error;
       }
   }
   //Error cand citesc din fisierul de input
   if (d == -1) {
       int error = errno;
       PrintMessage("Unable to read from input file!\n");
       return error;
   }
}


int main(int argc, char* arg[])
{
   //Se pot suprascrie fisiere
   int err_copy_file;
   
   //Fisierele sunt pasate ca parametrii.
   if (argc == 3)
       err_copy_file = CopyFile(arg[1], arg[2]);
   else {
       //Trebuie sa citim cele doua fisiere.
       const int BUFF = 1000;
       
       char input_file[BUFF];
       char output_file[BUFF];
       
       //Alocare memorie
       memset(input_file, 0, sizeof(input_file));
       memset(input_file, 0, sizeof(output_file));

       PrintMessage("Input File: ");
       read(0, input_file, BUFF);
       PrintMessage("Output File: ");
       read(0, output_file, BUFF);
      
       //Se elimina '\n' de la finalul sirurilor de caractere
       input_file[strlen(input_file) - 1] = output_file[strlen(output_file) - 1] = 0;

       err_copy_file = CopyFile(input_file, output_file);
   }
  
    //Se afiseaza error daca apare
    if (err_copy_file)
       PrintError("Error while copying files!\n", err_copy_file);

   return 0;
}
