%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"yazdir"				   {return dump;}
"cik"				   {return exit_shell;}
[a-zA-Z]			   {yylval.id = yytext[0];
					   return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); 
						return number;}
[ \t\n]                ;
[-+*/=;]           	   {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}

