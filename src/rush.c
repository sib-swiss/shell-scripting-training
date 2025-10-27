#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

#define MAX_TOKENS 256

#define VERBOSE 1

int parse_args (int argc, char *argv[]) {
	int options = 0;
	for (int i=0; i<argc; i++) {
		if (0 == strcmp("-v", argv[i])) 
			options |= VERBOSE;
	}
	return options;
}

ssize_t tokenize(char *str, const char *delim, char *args[]) {
	int i;
	memset(args, '\0', MAX_TOKENS);
	for (i=0; i < MAX_TOKENS; i++) {
		char *s, *token; 
		// strtok wants s = NULL on all but the first call
		if (0 == i) s = str; else s = NULL;
		if (token = strtok(s, delim)) {
			size_t tok_len = strlen(token);
			char *tok_cpy = (char *) malloc((1 + tok_len) * sizeof(char)); // +1: '\0'
			if (NULL == tok_cpy) {
				perror(NULL);
				exit(1);
			}
			strncpy(tok_cpy, token, tok_len+1);
			args[i] = tok_cpy;
		}
		else
			break;
	}
	return i;
}

int main (int argc, char* argv[]) {
	char    *delim   = " \n";
	ssize_t n        = 0;
	char *args[MAX_TOKENS];

	int options = parse_args(argc, argv);
	
	if (options & VERBOSE) 
		printf("Welcome to R U S H - the shell that can do almost nothing!\n");

	while (1) {
		printf ("rush > "); // prompt
		char    *lineptr = NULL;

		// get command line
		if (-1 == getline(&lineptr, &n, stdin)) 
                        if (feof(stdin)) { // handles Ctrl-D 
                                if (options & VERBOSE)
                                        printf("Bye!");
                                printf("\n");
                                exit(0);
                        }
                        else
                                perror(NULL);

		// split command line into words
		ssize_t n_tok = tokenize(lineptr, delim, args);

		// show arguments iff verbose
		if (options & VERBOSE) 
			for (int i=0; i < n_tok; i++) 
				printf ("word %d: '%s'\n", i, args[i]);

		// quit if command is "exit"
		if (0 == strcmp("exit", args[0])) 
			exit(0);

		// launch command
		pid_t pid = fork();
		switch (pid) {
			case -1: // error
				perror(NULL);
				break;
			case 0: // child
				execvp(args[0], args);
			default: // parent
				wait(NULL);
				break;
		}

		// Free tokens
		for (char **p = args; NULL != *p; p++) {
			free(*p);
		}

		free(lineptr);
	}


	exit(0);
}
