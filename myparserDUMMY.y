%{
  #include <stdio.h>
  #include "cgen.h"
  
  extern int yylex(void);
  extern int lineNum;
%}

%union
{
  char* str;
  int num;
}

%define parse.trace
%debug

%token <str> IDENTIFIER
%token <str> POSINT 
%token <str> REAL 
%token <str> STRING

%token ASSIGN

%token KW_IF
%token KW_THEN
%token KW_ELSE

%token KW_TRUE
%token KW_FALSE

%start input

%type <str> expr

%left '-' '+'
%left '*' '/'

%%

input:  
  %empty
| input expr ';' 
{ 
  if (yyerror_count == 0) {
    puts(c_prologue);
    printf("Expression evaluates to: %s\n", $2); 
  }  
}
;

expr:
  POSINT
| REAL
| '(' expr ')' { $$ = template("(%s)", $2); }
| expr '+' expr { $$ = template("%s + %s", $1, $3); }
| expr '-' expr { $$ = template("%s - %s", $1, $3); }
| expr '*' expr { $$ = template("%s * %s", $1, $3); }
| expr '/' expr { $$ = template("%s / %s", $1, $3); }
;

%%
int main () {
  if ( yyparse() == 0 )
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}
