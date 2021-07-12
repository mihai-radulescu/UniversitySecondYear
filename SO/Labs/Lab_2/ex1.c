#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

// Printez mesajul cu stdout
void PrintMessage(char* message) {
   // lungimea mesajului
   int len = strlen(message);
   // Nr-ul caracterelor printate
   int written = 0, d;
  
   // Printez
   while ((d = write(1, message + written, len - written)) > 0) {
       written += d;
   }
}

int main() {
   //Afisare Hello World.
   
   PrintMessage("Hello World!\n");
   
   return 0;
}
