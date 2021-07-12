#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

void* ReverseArray(void* v_vec) {
   char* vec = v_vec;

   int l = strlen(vec);

   char* ans = malloc(l + 1);

   ans[l] = 0;

   for (int i = 0; i < l; i++)
       ans[l - i - 1] = vec[i];

   return ans;
}

int main() {
   // Salveaza strigul.
   char* my_str = 0;

   // Citesc inputul.
   printf("Care este lungimea sirului?\n");

   int n;
   scanf("%d", &n);

   my_str = malloc(n + 1);
   my_str[n - 1] = 0;

   printf("Care este stringul?\n");

   scanf("\n");

   for (int i = 0; i < n; i++)
    scanf("%c", my_str + i);

    printf("\n");

   // Creez si lansez threadul.
   pthread_t thr;

   if (pthread_create(&thr, NULL, ReverseArray, my_str)) {
       perror(NULL);

       return errno;
   }

   char* ans;

   // Prind threadul.
   if (pthread_join(thr, (void**)&ans)) {
       perror(NULL);

       return errno;
   }

   // Afisez raspunsul.
   printf("Sirul rasturnat este:\n");
   printf("\"%s\"\n", ans);

   free(ans);

   return 0;
}
