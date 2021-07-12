#include <sys/wait.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>

/*
  Declararea functiilor predefinite
 */
int db_cd(char **args);
int db_help(char **args);
int db_exit(char **args);
int db_delete(char **args);
int db_list(char **args);
int db_copy(char **args);
int db_move(char **args);
int db_makedir(char** args);

/*
  Lista comenziilor
 */
char *builtin_str[] = {
  "cd",
  "help",
  "exit",
  "delete",
  "list",
  "copy",
  "move",
  "makedir"
};

int (*builtin_func[]) (char **) = {
  &db_cd,
  &db_help,
  &db_exit,
  &db_delete,
  &db_list,
  &db_copy,
  &db_move,
  &db_makedir
};

int db_num_builtins() {
  return sizeof(builtin_str) / sizeof(char *);
}

/*
  Implementarea functiilor predefinite
*/

/*
  Schimbare director
  args[0] = comanda, args[1] = directorul dorit 
 */
int db_cd(char **args)
{
  if (args[1] == NULL) {
    fprintf(stderr, "db: expected argument to \"cd\"\n");
  } else {
    if (chdir(args[1]) != 0) {
      perror("db");
    }
  }
  return 1;
}

/*
  Comanda de ajutor
 */
int db_help(char **args)
{
  int i;
  printf("Type program names and arguments, and hit enter.\n");
  printf("The following are built in:\n");

  for (i = 0; i < db_num_builtins(); i++) {
    printf("  %s\n", builtin_str[i]);
  }

  return 1;
}

/*
  Comanda care opreste programul
 */
int db_exit(char **args)
{
  return 0;
}

int db_delete(char **args){
  errno = 0;

    if(args[2] == NULL){
        if(remove(args[1])){
          fprintf(stderr, "%s: could not delete file %s;\n%s\n", 
          args[0], args[1], strerror(errno));
          return 1;
        }
    }else {
        puts("ERROR: ");
        fprintf(stderr, "Usage: %s [filename]\n", args[0]);
        return 1;
    }
  return 1;
}

/*
  Functie care afiseaza elementele din directorul curent
*/
int db_list(char **args){
  struct dirent **contents;
    int content_count;

    if(sizeof(args) / sizeof(char **) < 2){
        if((content_count = scandir("./", &contents, NULL, alphasort))<0){
            fprintf(stderr, "%s cannot list from %s\n%s\n", args[0], args[1], strerror(errno));
            return 1;
        }
    }
    else if(sizeof(args) / sizeof(char **) == 2){
        if((content_count = scandir(args[1], &contents, NULL, alphasort))<0){
            fprintf(stderr, "%s cannot list from %s\n%s\n", args[0], args[1], strerror(errno));
            return 1;
        }
    }
    else{
      puts("ERROR:");
      fprintf(stderr, "Usage: %s [directory]\n", args[0]);
      return 1;
    }
    
    int i;
    for(i=2; i<content_count; i++){
        puts(contents[i]->d_name);
    }
    
    return 1;
}

/*
  Functie care copiaza un fisier in alt fisier
*/
int db_copy(char **args){
  errno = 0;
  FILE *fpr, *fpw;
	char ch;

	if(args[2] == NULL){
		fprintf(stderr, "Syntax Error:\nUsage: %s [filename] [new filename]\n", args[0]);
    return 1;
	}	
	
  if((fpr = fopen(args[1], "rb")) == NULL){
		fprintf(stderr, "%s cannot copy %s to %s\n%s\n", args[0], args[1], args[2], strerror(errno));
    return 1;
	}
	
  if((fpw = fopen(args[2], "rb")) != NULL){
	  errno = EEXIST;
    fprintf(stderr, "%s cannot copy %s to %s\n%s\n", args[0], args[1], args[2], strerror(errno));
    return 1;
    }
	
  if((fpw = fopen(args[2], "wb")) == NULL){
	  fprintf(stderr, "%s cannot copy %s to %s\n%s\n", args[0], args[1], args[2], strerror(errno));
    return 1;
    }

	while((ch = getc(fpr))!= EOF){
		putc(ch, fpw);
	}

	fclose(fpr);
	fclose(fpw);
	
	return 1;
}

/*
  Functie care muta si redenumeste un fisier
*/
int db_move(char **args){
  errno = 0;
  FILE *fpr, *fpw;
	char ch;

	if(args[2] == NULL){
		fprintf(stderr, "SYNTAX ERROR:\nUsage: %s [old filename] [new filename]\n", args[0]);
    return 1;
	}
    else
     if(rename(args[1], args[2]) == -1){

        fprintf(stderr, "%s cannot move %s to %s\n%s\n", args[0], args[1], args[2], strerror(errno));
        return 1;
    }
    
    return 1;
}

/*
  Functie care creeaza un director
*/
int db_makedir(char** args){
   errno = 0;

    if(args[2] == NULL){
        if(mkdir(args[1], (S_IRWXG | S_IRWXU))){
          fprintf(stderr, "%s cannot make directory %s\n%s\n", args[0], args[1], strerror(errno));
          return 1;
        }
    }
    else{
      fprintf(stderr, "SYNTAX ERROR:\nUsage: %s [dir_name]\n", args[0]);
      return 1;
    }

    return 1;
}


/*
  Lanseaza un program si asteapta executia acestuia 
  Returneaza 1 pt a continua executia
 */
int db_launch(char **args)
{
  pid_t pid, wpid;
  int status;

  pid = fork();
  if (pid == 0) {
    // Proces copil
    if (execvp(args[0], args) == -1) {
      perror("db");
    }
    exit(EXIT_FAILURE);
  } else if (pid < 0) {
    // Eroare la fork
    perror("db");
  } else {
    // Proces parinte
    do {
      wpid = waitpid(pid, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));
  }

  return 1;
}

/*
  Functie care executa comenzile creeate
 */
int db_execute(char **args)
{
  int i;

  //Daca nu a fost data o comanda, continua
  if (args[0] == NULL) {
    return 1;
  }

  //Verific daca args[0] este o functie predefinita
  for (i = 0; i < db_num_builtins(); i++) {
    if (strcmp(args[0], builtin_str[i]) == 0) {
      return (*builtin_func[i])(args);
    }
  }

  //args[0] nu este o funtie predefinita si este executata cu fork
  return db_launch(args);
}

#define DB_RL_BUFSIZE 1024
/*
  Funtie care citeste input-ul dat
 */
char *db_read_line(void)
{
  int bufsize = DB_RL_BUFSIZE;
  int position = 0;
  char *buffer = malloc(sizeof(char) * bufsize);
  int c;

  if (!buffer) {
    fprintf(stderr, "db: allocation error\n");
    exit(EXIT_FAILURE);
  }

  while (1) {
    // Citire a unui caracter
    c = getchar();

    // Daca ajung la EOF, il inlocuiesc cu caracterul null si returnez
    if (c == EOF || c == '\n') {
      buffer[position] = '\0';
      return buffer;
    } else {
      buffer[position] = c;
    }
    position++;

    // Daca depasesc dimensiunea buffer-ului, realoc memoria
    if (position >= bufsize) {
      bufsize += DB_RL_BUFSIZE;
      buffer = realloc(buffer, bufsize);
      if (!buffer) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }
  }
}

#define DB_TOK_BUFSIZE 64
#define DB_TOK_DELIM " \t\r\n\a"
/*
  Functie care imparte linia citita in sir de argumente.
*/
char **db_split_line(char *line)
{
  int bufsize = DB_TOK_BUFSIZE, position = 0;
  char **tokens = malloc(bufsize * sizeof(char*));
  char *token;

  if (!tokens) {
    fprintf(stderr, "db: allocation error\n");
    exit(EXIT_FAILURE);
  }

  token = strtok(line, DB_TOK_DELIM);
  while (token != NULL) {
    tokens[position] = token;
    position++;

    if (position >= bufsize) {
      bufsize += DB_TOK_BUFSIZE;
      tokens = realloc(tokens, bufsize * sizeof(char*));
      if (!tokens) {
        fprintf(stderr, "db: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }

    token = strtok(NULL, DB_TOK_DELIM);
  }
  tokens[position] = NULL;
  return tokens;
}

/*
  Functie care asigura ciclul de rulare al unei comenzi
 */
void db_loop(void)
{
  char *line;
  char **args;
  int status;

  do {
    printf(":) >> ");
    line = db_read_line();
    args = db_split_line(line);
    status = db_execute(args);

    free(line);
    free(args);
  } while (status);
}


int main(int argc, char **argv)
{
  printf("Hello user. This is an experimetal shell\n");
  printf("Use at your own risk\n");

  db_loop();

  return EXIT_SUCCESS;
}