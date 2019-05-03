// %{
// #include <stdlib.h>
// #include <stdarg.h>
// #include <stdio.h>
// #include <string.h>		
// #include "cgen.h"

// extern int yylex(void);
// extern int lineNum;
// %}

// %union
// {
// 	char* crepr;
// }

// %define parse.trace
// %debug

// // #define ANSI_COLOR_RED     "\x1b[31m"
// //   #define ANSI_COLOR_GREEN   "\x1b[32m"
// //   #define ANSI_COLOR_CYAN    "\x1b[36m"
// //   #define ANSI_COLOR_RESET   "\x1b[0m"

// %token <crepr> TK_IDENT
// %token <crepr> TK_INT 
// %token <crepr> TK_REAL 
// %token <crepr> TK_STRING

// //KEYWORD DEFINITION
// %token KW_INT 
// %token KW_REAL 
// %token KW_BOOL 
// %token KW_STRING
// //TODO CHECK IF ELSE ETC
// %token KW_TRUE
// %token KW_FALSE
// %token KW_IF
// %token KW_THEN
// %token KW_ELSE
// %token KW_FI
// %token KW_WHILE
// %token KW_LOOP
// %token KW_POOL
// %token KW_CONST
// %token KW_LET
// %token KW_RETURN
// %token KW_AND
// %token KW_OR 
// %token KW_START


// %right KW_NOT 

// //DEFINE OPERATORS
// %left OP_PLUS
// %left OP_MINUS
// %left OP_MUL
// %left OP_DIV
// %left OP_MOD
// %left OP_EQUALS
// %left OP_NOT_EQUALS
// %left OP_SMALLER
// %left OP_SMALLER_EQUALS
// %left OP_ASSIGN

// %left OP_ARROW

// //DEFINE DELIMETERS
// %left DEL_SEMICOLON
// %left DEL_LEFT_PARENTESIS
// %left DEL_RIGHT_PARENTESIS
// %left DEL_COMMA
// %left DEL_LEFT_BRACKETS
// %left DEL_RIGHT_BRACKETS
// %left DEL_COLON
// //ADDED CURLY BRACKETS.NEEDED FOR FUNCTIONS
// %left DEL_LEFT_CURLY_BRACKETS
// %left DEL_RIGHT_CURLY_BRACKETS

// %start input

// %type <crepr> expr

// %%

// input:  
//   %empty
// | input expr ';' 
// { 
//   if (yyerror_count == 0) {
//     puts(c_prologue);
//     printf("Expression evaluates to: %s\n", $2); 
//   }  
// }
// ;

// expr:
//   TK_INT
// | TK_REAL
// //| '(' expr ')' { $$ = template("(%s)", $2); }
// | expr OP_PLUS expr { $$ = template("%s + %s", $1, $3); }
// | expr OP_MINUS expr { $$ = template("%s - %s", $1, $3); }
// | expr OP_MUL expr { $$ = template("%s * %s", $1, $3); }
// | expr OP_DIV expr { $$ = template("%s / %s", $1, $3); }
// ;

// %%
// int main () {
//   if ( yyparse() == 0 )
//     printf("Accepted!\n");
//   else
//     printf("Rejected!\n");
// }










%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int lineNum;
%}

%union
{
  char* str;
}

%define parse.trace
%debug

%token <str> TK_IDENT
%token <str> TK_INT 
%token <str> TK_REAL 
%token <str> TK_STRING



// %token <crepr> TK_IDENT
// %token <crepr> TK_INT 
// %token <crepr> TK_REAL 
// %token <crepr> TK_STRING

//%token ASSIGN

%token KW_IF
%token KW_THEN
%token KW_ELSE

%token KW_TRUE
%token KW_FALSE

%start input

%type <str> expr

%left '-' '+'
%left '*' '/'
%left DEL_SEMICOLON

%%

input:  
  %empty
| input expr DEL_SEMICOLON 
{ 
  if (yyerror_count == 0) {
    puts(c_prologue);
    printf("Expression evaluates to: %s\n", $2); 
  }  
}
;

expr:
  TK_INT
| TK_REAL
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
