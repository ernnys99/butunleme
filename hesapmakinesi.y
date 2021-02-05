%{
#include <stdio.h>     
#include <stdlib.h>
#define SYMBOL_TABLE_LEN 26
#define NOT_FILLED 0
int symbols[26];
int symbol_index(char symbol);
int addition(int a, int b);
int substraction(int a, int b);
int mult(int a, int b);
int divide_check(int a, int b);
int dump_screen(int a);
void update_symbol_table(char var, int value);
void initialize_symbol_table(int *symbol_table);
void exit_program();
void introduction_message();
void yyerror (char *s);
int yylex();
%}

%union {int num; char id;}  
%start start_sym
%token dump
%token exit_shell
%token <num> number
%token <id> identifier
%type <num> start_sym expression term 
%type <id> assignment






%%



start_sym    : assignment ';'		{;}
		| exit_shell ';'		{exit_program();}
		| dump expression ';'			{dump_screen($2);}
		| start_sym assignment ';'	{;}
		| start_sym dump expression ';'	{dump_screen($3);}
		| start_sym exit_shell ';'	{exit_program();}
        ;

assignment : identifier '=' expression  { update_symbol_table($1,$3); }
			;
expression    	: term                  {$$ = $1;}
       	| expression '+' term          {$$ = addition($1, $3);}
       	| expression '-' term          {$$ = substraction($1, $3);}
       	| expression '*' term          {$$ = mult($1, $3);}
       	| expression '/' term          {$$ = divide_check($1, $3);}
       	;
term   	: number                {$$ = $1;}
		| identifier			{$$ = symbol_index($1);} 
        ;

%%                   

int divide_check(int a, int b)
{
	if(b == 0)
	{
		fprintf(stderr, "You can't divide by zero. Terminating program...");
		exit(0);
	}
	return a / b;
}
int addition(int a, int b)
{
	return a + b;
}
int substraction(int a, int b)
{
	return a - b;
}
int mult(int a, int b)
{
	return a * b;
}

int get_symbol_index(char var)
{
	int index;
	if(var >= 'a' && var <= 'z')
    {
        index = var - 'a';
    }
    else
    {
    	fprintf(stderr, "The token [%c] is can not be interpreted as a character. Please only use single english characters. Exiting the program...", var);
    	exit(0);
    }
    return index;
} 


int symbol_index(char var)
{
	return symbols[get_symbol_index(var)];
}


void update_symbol_table(char var, int value)
{
	symbols[get_symbol_index(var)] = value;
}

void initialize_symbol_table(int *symbol_table)
{
	int i;
	for(i = 0 ; i < SYMBOL_TABLE_LEN  ; ++i)
	{
		symbol_table[i] = NOT_FILLED;
	}
}
int* allocate_symbol_table()
{
	int *symbol_table;
	symbol_table = malloc(SYMBOL_TABLE_LEN * sizeof(int));
	return symbol_table;
}

int dump_screen(int a)
{
	fprintf(stdout, "Ekrana yazdiriliyor = [ %d ]\n", a);
}

void exit_program()
{
	fprintf(stdout, "Programdan cikiliyor...Hoscakal.\n");
	exit(EXIT_SUCCESS);
}
int main(void)
{
	int *symbol_table = allocate_symbol_table();
	initialize_symbol_table(symbol_table);
	introduction_message();
	return yyparse();
}

void yyerror (char *s) 
{
	fprintf (stderr, "%s\n", s);
} 
void introduction_message()
{
	fprintf(stdout, "Hesap makinesi programi basladi.\n'cik;' yazarak programdan cikabilir,\n'yazdir [degisken_ismi];' yazarak degiskenleri ekrana yazdirabilirsiniz.\n");
}

