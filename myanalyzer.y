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
  char* crepr;
}

%define parse.trace
%debug

// #define ANSI_COLOR_RED     "\x1b[31m"
//   #define ANSI_COLOR_GREEN   "\x1b[32m"
//   #define ANSI_COLOR_CYAN    "\x1b[36m"
//   #define ANSI_COLOR_RESET   "\x1b[0m"

%token <crepr> TK_IDENT
%token <crepr> TK_INT 
%token <crepr> TK_REAL 
%token <crepr> TK_STRING

//KEYWORD DEFINITION
%token KW_INT 
%token KW_REAL 
%token KW_BOOL 
%token KW_STRING
//TODO CHECK IF ELSE ETC
%token KW_TRUE
%token KW_FALSE
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_FI
%token KW_WHILE
%token KW_LOOP
%token KW_POOL
%token KW_CONST
%token KW_LET
%token KW_RETURN
%token KW_AND
%token KW_OR 
%token KW_START


%right KW_NOT 

//DEFINE OPERATORS
%left OP_PLUS
%left OP_MINUS
%left OP_MUL
%left OP_DIV
%left OP_MOD
%left OP_EQUALS
%left OP_NOT_EQUALS
%left OP_SMALLER
%left OP_SMALLER_EQUALS
%left OP_ASSIGN

%left OP_ARROW

//DEFINE DELIMETERS
%left DEL_SEMICOLON
%left DEL_LEFT_PARENTESIS
%left DEL_RIGHT_PARENTESIS
%left DEL_COMMA
%left DEL_LEFT_BRACKETS
%left DEL_RIGHT_BRACKETS
%left DEL_COLON
//ADDED CURLY BRACKETS.NEEDED FOR FUNCTIONS
%left DEL_LEFT_CURLY_BRACKETS
%left DEL_RIGHT_CURLY_BRACKETS


%type <crepr> data_types

%type <crepr> specialExpr
%type <crepr> notExpression
%type <crepr> signExpression
%type <crepr> multiplicativeExpression
%type <crepr> additiveExpression
%type <crepr> relationalExpression

%type <crepr> logicalExpressions

%type <crepr> expression


//FINAL
%type <crepr> __statement_list
%type <crepr> __statement_decl
%type <crepr> __statement_empty
%type <crepr> __statement
%type <crepr> __selection 
%type <crepr> __iteration
%type <crepr> __return
%type <crepr> __function
//%type <crepr> __selectionBody
%type <crepr> func_var_list

%type <crepr> translation_unit
%type <crepr> external_declaration


//MYMAIN
%type <crepr> main_body


%type <crepr> func_list

%type <crepr> func_param
%type <crepr> func_ret
%type <crepr> func_main
//%type <crepr> func_param_empty
%type <crepr> func_param_list


%type <crepr> decl
%type <crepr> const_decl_body
%type <crepr> const_decl_list
%type <crepr> const_decl_init
%type <crepr> let_decl_body
%type <crepr> let_decl_list
%type <crepr> let_decl_init
%type <crepr> decl_id
%type <crepr> type_spec

%type <crepr> input
%start input


%%

/*******************************************************************
* START FUNCTIONS(Variable declaration, function declaration etc)
*******************************************************************/

input
      : main_body                  
      { 
          $$ = template("%s",$1); 
          if (yyerror_count == 0) 
          {
                printf("\n********************** C Code ********************** \n");
                printf("\n%s\n", $1);
                //printf("%s\n",$2);
                //printf("%s\n",$3);
                printf("\n********************** C Code ********************** \n");
                printf("\nSaving code in output.c for further use.\n");
                     FILE *fp = fopen("output.c","w");
                     fputs("#include <stdio.h>\n",fp);
                     //fputs("#include teaclib.h\n",fp);
            fputs(c_prologue,fp);
                fprintf(fp,"%s\n", $1);
                //fprintf(fp,"%s", $2);
                //fprintf(fp,"%s", $3);  
      fclose(fp);               
          }
          else
          {
                printf("\nCompilation error!\n");
                printf("\nResult: Rejected!\n");
                exit(0); 
          }
      }                               
      ;
  
  /*
    We ensure each time that we have a main function. Function and variable declaration are not always nessecary.Ensure that
  */
main_body
  : func_main    { $$ = template("%s\n",$1); }
  | translation_unit func_main    { $$ = template("%s\n%s\n",$1,$2); }
  | func_main translation_unit   { $$ = template("%s\n%s\n",$1,$2); }
  | translation_unit func_main translation_unit   { $$ = template("%s\n%s\n%s\n",$1,$2,$3); }
  ;

translation_unit
  : external_declaration                     { $$ = template("%s\n",$1); }
  | translation_unit external_declaration    { $$ = template("%s\n%s\n",$1,$2); }  
  ;

external_declaration
  : decl   { $$ = template("%s",$1); }  //Declaration variable part. Done
  | func_list          { $$ = template("%s",$1); } //Declaration function part. Done
  ;  


/*******************************************************************
* DECLARATIONS
*******************************************************************/

decl
  : KW_LET let_decl_body { $$ = template("%s", $2); }
  | KW_CONST const_decl_body { $$ = template("const %s", $2); }
  ;

/*
  The three function below handle const variable declaration
*/
const_decl_body
  : const_decl_list DEL_COLON type_spec DEL_SEMICOLON {  $$ = template("%s %s;", $3, $1); }
  ;

const_decl_list
  : const_decl_list DEL_COMMA const_decl_init { $$ = template("%s, %s", $1, $3 );}
  | const_decl_init
  ;

const_decl_init
  :  decl_id OP_ASSIGN data_types { $$ = template("%s = %s", $1, $3); }
  ;


/*
  The three function below handle let variable declaration
*/
let_decl_body
  : let_decl_list DEL_COLON type_spec DEL_SEMICOLON {  $$ = template("%s %s;", $3, $1); }
  ;

let_decl_list
  : let_decl_list DEL_COMMA let_decl_init { $$ = template("%s, %s", $1, $3 );}
  | let_decl_init
  ;

let_decl_init
  : decl_id
  | decl_id OP_ASSIGN data_types { $$ = template("%s = %s", $1, $3); }
  ; 

/*
 * Array declaration must be a positive integer number. Valid example test[2]. We also allow array initialization
 */
decl_id
  : TK_IDENT { $$ = template("%s", $1); }
  | TK_IDENT DEL_LEFT_BRACKETS TK_INT DEL_RIGHT_BRACKETS { $$ = template("%s[%s]", $1, $3); }

  ;

type_spec
  : KW_INT    { $$ = template("%s", "int"); }
  | KW_BOOL    { $$ = template("%s", "int"); }
  | KW_REAL   { $$ = template("%s", "double"); }
  | KW_STRING     { $$ = template("%s", "char*"); }
  ;




/*******************************************************************
* FUNCTIONS
*******************************************************************/

func_list
  :  KW_CONST decl_id OP_ASSIGN DEL_LEFT_PARENTESIS func_param_list DEL_RIGHT_PARENTESIS DEL_COLON func_ret OP_ARROW DEL_LEFT_CURLY_BRACKETS __statement_empty  DEL_RIGHT_CURLY_BRACKETS DEL_SEMICOLON { $$ = template("%s %s(%s) {\n%s\n};\n",$8, $2, $5, $11); }
  ;

/*
  Our main function format
*/
func_main
  :KW_CONST KW_START OP_ASSIGN DEL_LEFT_PARENTESIS DEL_RIGHT_PARENTESIS DEL_COLON KW_INT OP_ARROW DEL_LEFT_CURLY_BRACKETS __statement_empty  DEL_RIGHT_CURLY_BRACKETS DEL_SEMICOLON { $$ = template("int main(){\n%s}",$10); } 
  ;


// func_param_empty
//   : %empty                             { $$ = template("");}
//   | func_param_list DEL_COLON type_spec     { $$ = template("%s : %s", $1,$3); }

// func_param_list
//   : func_param                            { $$ = template("%s", $1);}
//   | func_param_empty DEL_COMMA func_param     { $$ = template("%s , %s", $1,$3); }



// func_param_list
//   : %empty              { $$ = template("");}
//   | func_param_empty DEL_COMMA func_param_list     { $$ = template("%s , %s", $1,$3); }
//   | func_param_empty                            { $$ = template("%s", $1);}
  
// func_param_empty
//   : func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }
//   //| func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }




func_param_list
  : %empty              { $$ = template("");}
  | func_param DEL_COMMA func_param DEL_COLON type_spec DEL_COMMA func_param_list     { $$ = template("%s %s ,%s %s, %s",$5,$1,$5,$3,$7); }
  | func_param DEL_COMMA func_param DEL_COLON type_spec    { $$ = template("%s %s, %s %s", $5,$1,$5,$3); }
  | func_param DEL_COLON type_spec DEL_COMMA func_param_list     { $$ = template("%s %s , %s", $3,$1,$5); }
  | func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }
  //| func_param type_spec     { $$ = template("%s", $2); }
  
  //| func_param_list func_param_list     { $$ = template("%s %s", $1,$3); }
  
 // func_param_bonus
 //  : func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }
// func_param_empty
//   : func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }
//   //| func_param DEL_COLON type_spec     { $$ = template("%s %s", $3,$1); }


func_param
  : TK_IDENT { $$ = template("%s", $1); }
  | TK_IDENT DEL_LEFT_BRACKETS DEL_RIGHT_BRACKETS { $$ = template("%s[]", $1); }
  ;

func_ret
  : type_spec { $$ = template("%s", $1); }
  | DEL_LEFT_BRACKETS DEL_RIGHT_BRACKETS type_spec { $$ = template("%s*", $3); }
  ;

func_var_list
  : %empty                             { $$ = template("");}
  | func_var_list DEL_COMMA expression     { $$ = template("%s , %s", $1,$3); }
  | expression                            { $$ = template("%s", $1);}


/*******************************************************************
* STATEMENT SECTION
*******************************************************************/

__statement_empty
  : %empty              { $$ = template("");}
  | __statement_list                            { $$ = template("%s", $1);}

__statement_list
      
  : __statement_decl { $$ = template("\t%s\n", $1); }
  | __statement_list __statement_decl { $$ = template("%s\n\t%s\n", $1, $2); }
  ;

__statement_decl
  : decl   { $$ = template("%s",$1); }
  | __statement { $$ = template("%s",$1); }
  ;

__statement
  : TK_IDENT OP_ASSIGN expression DEL_SEMICOLON         { $$ = template("%s = %s;",$1, $3); } 
  //| TK_IDENT OP_ASSIGN __fun DEL_SEMICOLON         { $$ = template("%s = %s;",$1, $3); }
  //| 
  //KW_FI DEL_SEMICOLON { $$ = template("\t}\n"); }
  | __selection      { $$ = template("%s",$1); }
  | __iteration           { $$ = template("%s",$1); }
  | __function        { $$ = template("%s",$1); }
  | __return         { $$ = template("%s",$1); }
  ;

__function
  : TK_IDENT DEL_LEFT_PARENTESIS func_var_list DEL_RIGHT_PARENTESIS DEL_SEMICOLON                     { $$ = template("%s(%s);\n",$1,$3); }
  //| TK_IDENT DEL_LEFT_PARENTESIS func_var_list DEL_RIGHT_PARENTESIS DEL_SEMICOLON                     { $$ = template("%s();\n",$1); }
  ;
  

__selection
  : KW_FI DEL_SEMICOLON { $$ = template("\t}\n"); }
  | KW_IF expression KW_THEN __statement_empty                     { $$ = template("if(%s){\n%s",$2,$4); }
  | KW_IF expression KW_THEN __statement_empty KW_ELSE __statement_empty   { $$ = template("if(%s){\n%s\n\t}else{\n\t%s",$2,$4,$6); }



  // KW_IF expression KW_THEN __statement_empty KW_FI DEL_SEMICOLON                     { $$ = template("if(%s){\n%s\t}",$2,$4); }
  // | KW_IF expression KW_THEN __statement_empty KW_ELSE __statement_empty KW_FI DEL_SEMICOLON   { $$ = template("if(%s){\n%s\n\t}else{\n%s\t}",$2,$4,$6); }

// __selectionBody
//   : __statement_empty  { $$ = template("%s",$1); }
  //| __statement_empty KW_FI DEL_SEMICOLON { $$ = template("%s",$1); }
  //|

  // | KW_IF expression KW_THEN __statement_empty KW_ELSE KW_IF expression KW_THEN __statement_empty KW_THEN    { $$ = template("if(%s){\n%s\n\t}else if(%s){\n%s\t}",$2,$4,$7,$9); }
  //: KW_FI DEL_SEMICOLON { $$ = template("}"); }
  //| KW_IF expression KW_THEN __statement_empty                      { $$ = template("if(%s){\n%s\t",$2,$4); }
  // | KW_IF expression KW_THEN __statement_empty KW_ELSE __statement_empty   { $$ = template("if(%s){\n%s\n\t}else{\n%s\t",$2,$4,$6); }
  // | KW_IF expression KW_THEN __statement_empty                      { $$ = template("if(%s){\n%s\t",$2,$4); }


  // | KW_IF expression KW_THEN __statement_empty KW_ELSE KW_IF expression KW_THEN __statement_empty KW_THEN    { $$ = template("if(%s){\n%s\n\t}else if(%s){\n%s\t}",$2,$4,$7,$9); }
  // | KW_ELSE KW_IF expression KW_THEN __statement_empty KW_ELSE KW_IF expression KW_THEN __statement_empty    { $$ = template("else if(%s){\n%s\n\t}else if(%s){\n%s\t}",$3,$5,$8,$10); }
  // | KW_ELSE KW_IF expression KW_THEN __statement_empty KW_ELSE __statement_empty   { $$ = template("else if(%s){\n%s\n\t}else{\n%s\t}",$3,$5,$7); }
  // | KW_ELSE KW_IF expression KW_THEN __statement_empty KW_ELSE KW_IF __statement_empty KW_FI DEL_SEMICOLON   { $$ = template("else if(%s){\n%s\n\t}",$3,$5,$8); }
  // | KW_ELSE __statement_empty KW_FI DEL_SEMICOLON   { $$ = template("else{\n%s\n\t}",$2); }
  ;
  ;

__iteration
  : KW_WHILE expression KW_LOOP __statement_empty KW_POOL DEL_SEMICOLON { $$ = template("while(%s){\n%s\n\t}",$2,$4); }
  ;

__return
  : KW_RETURN DEL_SEMICOLON               { $$ = template("return;"); }
  | KW_RETURN expression DEL_SEMICOLON { $$ = template("return %s;",$2); }
  ;


/*******************************************************************
* EXPRESSION SECTION
*******************************************************************/
data_types
  : TK_IDENT         { $$ = template("%s", $1); }
  | TK_INT            { $$ = template("%s", $1); }
  | TK_REAL              { $$ = template("%s", $1); }
  | TK_STRING             { $$ = template("%s", $1); }
  | KW_TRUE           { $$ = "1"; }
  | KW_FALSE           { $$ = "0"; }
  ;


specialExpr
  : data_types
  | TK_IDENT DEL_LEFT_BRACKETS expression DEL_RIGHT_BRACKETS              { $$ = template("%s[%s]",$1,$3); }
  //| __function 
  //| TK_IDENT DEL_LEFT_PARENTESIS expression DEL_RIGHT_PARENTESIS              { $$ = template("%s(%s)",$1,$3); }  TODO ADD THIS FUNCTION
  //| DEL_LEFT_PARENTESIS DEL_RIGHT_PARENTESIS                   { $$ = template("()"); }

  | DEL_LEFT_PARENTESIS expression DEL_RIGHT_PARENTESIS              { $$ = template("(%s)", $2); }
  | TK_IDENT DEL_LEFT_PARENTESIS  DEL_RIGHT_PARENTESIS              { $$ = template("%s()",$1); }
  | TK_IDENT DEL_LEFT_PARENTESIS expression  DEL_RIGHT_PARENTESIS              { $$ = template("%s(%s)",$1,$3); }
  //| __function 
  ;


notExpression
  : specialExpr
  | KW_NOT signExpression  { $$ = template("not %s", $2); }
  ;

signExpression
  : notExpression
  | OP_PLUS notExpression    { $$ = template("+%s", $2); }
  | OP_MINUS notExpression    { $$ = template("-%s", $2); }
  ;

multiplicativeExpression
  : signExpression
  | multiplicativeExpression OP_MUL signExpression           { $$ = template("%s * %s", $1, $3); }
  | multiplicativeExpression OP_DIV signExpression           { $$ = template("%s / %s", $1, $3); }
  | multiplicativeExpression OP_MOD signExpression        { $$ = template("%s %% %s", $1, $3); }
  ;

additiveExpression
  : multiplicativeExpression
  | additiveExpression OP_PLUS multiplicativeExpression         { $$ = template("%s + %s", $1, $3); }
  | additiveExpression OP_MINUS multiplicativeExpression         { $$ = template("%s - %s", $1, $3); }
  ;

relationalExpression
  : additiveExpression
  | relationalExpression OP_EQUALS additiveExpression         { $$ = template("%s == %s", $1, $3); }
  | relationalExpression OP_NOT_EQUALS additiveExpression    { $$ = template("%s != %s", $1, $3); }
  | relationalExpression OP_SMALLER additiveExpression         { $$ = template("%s < %s", $1, $3); }
  | relationalExpression OP_SMALLER_EQUALS additiveExpression   { $$ = template("%s <= %s", $1, $3); }
  ;



logicalExpressions
  : relationalExpression
  | logicalExpressions KW_AND relationalExpression        { $$ = template("%s and %s", $1, $3); }
  | logicalExpressions KW_OR relationalExpression        { $$ = template("%s or %s", $1, $3); }
  ;

expression
  : logicalExpressions  { $$ = template("%s", $1); }
  ;


%%
int main () {
  if ( yyparse() == 0 )
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}