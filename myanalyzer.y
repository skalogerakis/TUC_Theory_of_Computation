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
// %type <crepr> assignment_expression
%type <crepr> logicalAndExpression
//%type <crepr> logicalOrExpression
%type <crepr> expression

// %type <crepr> statement
// %type <crepr> begin_end_statement
// %type <crepr> expression_statement
// %type <crepr> for_expression_statement
// %type <crepr> if_statement
// %type <crepr> jump_statement
// %type <crepr> loop_statement
// %type <crepr> statement_list
// %type <crepr> declaration_list
%type <crepr> __statement
%type <crepr> __selection 
%type <crepr> __iteration
%type <crepr> __return

%type <crepr> declaration
%type <crepr> declaration_specifiers
%type <crepr> init_declarator
%type <crepr> type_specifier
%type <crepr> declarator
%type <crepr> parameter_list
%type <crepr> array_declare
%type <crepr> declaration_list
// %type <crepr> translation_unit
// %type <crepr> global_declaration
// %type <crepr> function_declaration
// %type <crepr> program


//TODO CHANGE THAT %start input
%type <crepr> input
%start input

//%start program

//%type <crepr> expr

%%

//TODO INIT COMMIT
// input:  
//   %empty
// | expression 
// { 
//   if (yyerror_count == 0) {
//     puts(c_prologue);
//     //printf("Expression evaluates to: %s\n", $2); 
//   }  
// }
// ;


//EXPRESION SECTION IS DONE TODO MAYBE SOMETHING IS WRONG WITH NOT.CHECK SEPERATELY
/*******************************************************************
* Expressions
*******************************************************************/
data_types
  : TK_IDENT         { $$ = template("%s", $1); }
  | TK_INT            { $$ = template("%s", $1); }
  | TK_REAL              { $$ = template("%s", $1); }
  | TK_STRING             { $$ = template("%s", $1); }
  ;


//TODO ADD FUNCTION
specialExpr
  : data_types
  | TK_IDENT DEL_LEFT_BRACKETS expression DEL_RIGHT_BRACKETS              { $$ = template("%s[%s]",$1,$3); }
  //| TK_IDENT DEL_LEFT_PARENTESIS expression DEL_RIGHT_PARENTESIS              { $$ = template("%s(%s)",$1,$3); }  TODO ADD THIS FUNCTION
  | DEL_LEFT_PARENTESIS expression DEL_RIGHT_PARENTESIS              { $$ = template("(%s)", $2); } 
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
  | multiplicativeExpression OP_MOD signExpression        { $$ = template("%s % %s", $1, $3); }
  ;

additiveExpression
  : multiplicativeExpression
  | additiveExpression OP_PLUS multiplicativeExpression         { $$ = template("%s + %s", $1, $3); }
  | additiveExpression OP_MINUS multiplicativeExpression         { $$ = template("%s - %s", $1, $3); }
  ;

relationalExpression
  : additiveExpression
  | relationalExpression OP_EQUALS additiveExpression         { $$ = template("%s = %s", $1, $3); }
  | relationalExpression OP_NOT_EQUALS additiveExpression    { $$ = template("%s != %s", $1, $3); }
  | relationalExpression OP_SMALLER additiveExpression         { $$ = template("%s < %s", $1, $3); }
  | relationalExpression OP_SMALLER_EQUALS additiveExpression   { $$ = template("%s <= %s", $1, $3); }
  ;



logicalAndExpression
  : relationalExpression
  | logicalAndExpression KW_OR relationalExpression        { $$ = template("%s or %s", $1, $3); }
  | logicalAndExpression KW_AND relationalExpression        { $$ = template("%s and %s", $1, $3); }
  ;

// logicalOrExpression
//   : logicalAndExpression
//   | logicalOrExpression KW_OR logicalAndExpression        { $$ = template("%s or %s", $1, $3); }
// ;

expression
  : logicalAndExpression
  ;

//TODO THIS SECTION NEEDS SOME WORK
/*******************************************************************
* Statements
*******************************************************************/

__statement
  //: __mainbody       { $$ = template("%s",$1); }
  : TK_IDENT OP_ASSIGN expression DEL_SEMICOLON         { $$ = template("%s <- %s;",$1, $3); }
  | __selection      { $$ = template("%s",$1); }
  | __iteration           { $$ = template("%s",$1); }
  | __return         { $$ = template("%s",$1); }
  //| expression_statement     { $$ = template("%s",$1); }
  //| if_statement           { $$ = template("%s",$1); }
  // | jump_statement           { $$ = template("%s",$1); }
  // | loop_statement           { $$ = template("%s",$1); }
  ;

//TODO ADD OPTIONAL CHOICES
// __mainbody
//   : DEL_LEFT_CURLY_BRACKETS DEL_RIGHT_CURLY_BRACKETS { $$ = template("\n{\n}\n\n"); }

// statement_list
//   : statement                { $$ = template("%s",$1); }
//   | statement_list statement { $$ = template("%s %s",$1,$2); }
//   ;
  
// declaration_list
//   : declaration                { $$ = template("%s",$1); }
//   | declaration_list declaration { $$ = template("%s %s",$1,$2); }
//   ; 

// begin_end_statement
//   : KW_BEGIN KW_END                                { $$ = template("\n{\n}\n\n"); }
//   | KW_BEGIN statement_list KW_END                       { $$ = template("\n{\n %s}\n\n",$2); }
//   | KW_BEGIN declaration_list KW_END               { $$ = template("\n{\n %s}\n\n",$2); } 
//   | KW_BEGIN declaration_list statement_list KW_END      { $$ = template("{\n %s %s \n}\n",$2,$3); }  
//   ;

// expression_statement
//   : expression OP_SEMICOLON   { $$ = template("%s;\n",$1); }
//   | OP_SEMICOLON              { $$ = template(";\n"); }
//   ;

// for_expression_statement
//   : expression OP_SEMICOLON   { $$ = template("%s;",$1); }
//   | OP_SEMICOLON              { $$ = template(";"); }
//   ;

//TODO THIS IS THE RIGHT
__selection
  : KW_IF expression KW_THEN __statement KW_FI DEL_SEMICOLON                     { $$ = template("if %s then\n %s \nfi;\n",$2,$4); }
  | KW_IF expression KW_THEN __statement KW_ELSE __statement KW_FI DEL_SEMICOLON   { $$ = template("if %s then\n %s \nelse\n %s fi;\n",$2,$4,$6); }
  ;

__iteration
  : KW_WHILE expression KW_LOOP __statement KW_POOL DEL_SEMICOLON { $$ = template("while %s loop\n %s \npool;\n",$2,$4); }
  ;

__return
  : KW_RETURN DEL_SEMICOLON               { $$ = template("return;"); }
  | KW_RETURN expression DEL_SEMICOLON { $$ = template("return %s;",$2); }
// __assign
//   : TK_IDENT OP_ASSIGN expression
  


/*******************************************************************
* Program
*******************************************************************/

input
      : %empty                        {$$ = template("");}
      | __statement              
      { 
          $$ = template("%s",$1); 
          if (yyerror_count == 0) 
          {
                printf("\n********************** C Code ********************** \n");
                printf("\n%s\n", $1);
                printf("\n********************** C Code ********************** \n");
                printf("\nSaving code in output.c for further use.\n");
                     FILE *fp = fopen("output.c","w");
                     fputs("#include <stdio.h>\n",fp);
            fputs(c_prologue,fp);
                fprintf(fp,"%s", $1); 
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
  
// translation_unit
//   : global_declaration                     { $$ = template("%s",$1); }
//   | translation_unit global_declaration    { $$ = template("%s %s",$1,$2); }  
//   ;

// global_declaration
//   : function_declaration  { $$ = template("%s",$1); }
//   | declaration           { $$ = template("%s",$1); } 
//   ;  

// function_declaration
//   : declaration_specifiers TK_IDENT DEL_LEFT_PARENTESIS parameter_list DEL_RIGHT_PARENTESIS begin_end_statement       { $$ = template("%s %s(%s) %s",$1,$2,$4,$6); }
//   | declaration_specifiers TK_IDENT DEL_LEFT_PARENTESIS DEL_RIGHT_PARENTESIS begin_end_statement                      { $$ = template("%s %s() %s",$1,$2,$5);}  
// ;




/*******************************************************************
* Declarations
*******************************************************************/

// type_specifier
//   : KW_VOID   { $$ = template("%s", "void"); }
//   //| KW_CHAR   { $$ = template("%s", "char"); }
//   | KW_INTEGER    { $$ = template("%s", "int"); }
//   | KW_BOOLEAN    { $$ = template("%s", "int"); }
//   | KW_REAL   { $$ = template("%s", "double"); }
//   | KW_STRING     { $$ = template("%s", "char*"); }
//   ;

/*
 * The main type of specifiers as defined from assignment
 */
type_specifier
  : KW_INT    { $$ = template("%s", "int"); }
  | KW_BOOL    { $$ = template("%s", "bool"); }
  | KW_REAL   { $$ = template("%s", "real"); }
  | KW_STRING     { $$ = template("%s", "string"); }
  ;

parameter_list
  : declaration_specifiers declarator                    { $$ = template("%s %s",$1,$2); }
  | parameter_list DEL_COMMA declaration_specifiers declarator      { $$ = template("%s,%s %s",$1,$3,$4); }
  | parameter_list DEL_COMMA declaration_specifiers       { $$ = template("%s,%s",$1,$3); }
  ;

declarator
  : TK_IDENT                                                      { $$ = template("%s",$1); }
  | TK_IDENT DEL_LEFT_PARENTESIS DEL_RIGHT_PARENTESIS                                   { $$ = template("%s()",$1); }
  | TK_IDENT DEL_LEFT_PARENTESIS parameter_list DEL_RIGHT_PARENTESIS                    { $$ = template("%s(%s)",$1,$3); }
  | TK_IDENT DEL_LEFT_BRACKETS operation_expression DEL_RIGHT_BRACKETS array_declare  { $$ = template("%s[%s]%s",$1,$3,$5); } 
 ; 

array_declare
  : %empty                                             { $$ = template(""); }
  //| DEL_LEFT_BRACKETS operation_expression DEL_RIGHT_BRACKETS array_declare       { $$ = template("[%s]%s",$2,$4); }
  ;
  
init_declarator
  : declarator                                             { $$ = template("%s",$1); }
  //| declarator OP_ASSIGN assignment_expression         { $$ = template("%s<-%s",$1,$3); }
  | init_declarator DEL_COMMA init_declarator               { $$ = template("%s,%s",$1,$3); }  
  ;  

declaration_specifiers
  : KW_CONST                    { $$ = template("const"); }
  | KW_LET                      { $$ = template("let"); }
  ;

declaration
  : declaration_specifiers init_declarator DEL_SEMICOLON      { $$ = template("%s %s;\n", $1,$2); }
  ;



//SK EDIT START
/*
 * Used for initialization purposes
 */
// init_declarator
//   : TK_IDENT
//   | TK_IDENT OP_ASSIGN data_types { $$ = template("%s <- %s",$1,$3); }

/*
 * Used to declare multiple variables
 */
// declaration_list
//   : init_declarator
//   | init_declarator DEL_COMMA declaration_list   { $$ = template("%s,%s",$1,$3); }

/*
 * We have two different cases. In case of const we must also initialize.
 * In case of any other variable this option is optional
 */
// declaration
//   : KW_LET declaration_list DEL_COLON type_specifier DEL_SEMICOLON { $$ = template("let %s : %s;\n",$2,$4); }
//   | KW_CONST declaration_list DEL_COLON type_specifier DEL_SEMICOLON { $$ = template("const %s : %s;\n",$2,$4); }
//   ;
//SK EDIT FIN

// expr:
//   TK_INT
// | TK_REAL
// //| '(' expr ')' { $$ = template("(%s)", $2); }
// | expr OP_PLUS expr { $$ = template("%s + %s", $1, $3); }
// | expr OP_MINUS expr { $$ = template("%s - %s", $1, $3); }
// | expr OP_MUL expr { $$ = template("%s * %s", $1, $3); }
// | expr OP_DIV expr { $$ = template("%s / %s", $1, $3); }
// | expr OP_MOD expr { $$ = template("%s % %s", $1, $3); }
// ;









%%
int main () {
  if ( yyparse() == 0 )
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}


