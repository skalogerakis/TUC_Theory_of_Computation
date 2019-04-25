%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}


%token <crepr> IDENT
%token <crepr> POSINT 
%token <crepr> REAL 
%token <crepr> STRING

%token KW_START 
%token KW_CONST
%token KW_LET
%token KW_INT
%token KW_REAL
%token KW_STRING

%token ASSIGN
%token ARROW

%start program

%type <crepr> decl_list body decl
%type <crepr> const_decl_body const_decl_list const_decl_init const_decl_id
%type <crepr> type_spec
%type <crepr>  expr

%%

program: decl_list KW_CONST KW_START ASSIGN '(' ')' ':' KW_INT ARROW '{' body '}' { 
/* We have a successful parse! 
  Check for any errors and generate output. 
*/
	if(yyerror_count==0) {
    // include the teaclib.h file
	  puts(c_prologue); 
	  printf("/* program */ \n\n");
	  printf("%s\n\n", $1);
	  printf("int main() {\n%s\n} \n", $11);
	}
}
;

decl_list: decl_list decl { $$ = template("%s\n%s", $1, $2); }
| decl { $$ = $1; }
;

decl: KW_CONST const_decl_body { $$ = template("const %s", $2); }

;

const_decl_body: const_decl_list ':' type_spec ';' {  $$ = template("%s %s;", $3, $1); }
;

const_decl_list: const_decl_list ',' const_decl_init { $$ = template("%s, %s", $1, $3 );}
| const_decl_init { $$ = $1; }
;

const_decl_init: const_decl_id { $$ = $1; }
| const_decl_id ASSIGN expr { $$ = template("%s=%s", $1, $3); 
}
; 

const_decl_id: IDENT { $$ = $1; } 
| IDENT '['']' { $$ = template("*%s", $1); }
;

type_spec:  KW_INT { $$ = "int"; }
| KW_REAL { $$ = "double"; }
;

expr: POSINT { $$ = $1; }
| REAL { $$ = $1; }
;

body: { $$="";}
;

%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

