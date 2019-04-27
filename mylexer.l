%{
  //All defines needed are here.Maybe check if can be used in external file.
  #define ANSI_COLOR_RED     "\x1b[31m"
  #define ANSI_COLOR_GREEN   "\x1b[32m"
  #define ANSI_COLOR_RESET   "\x1b[0m"

  #define TK_IDENT 258
  #define TK_INT 259
  #define TK_REAL 260
  #define TK_STRING 261

  //KEYWORD DEFINTION
  #define KW_INT 210
  #define KW_REAL 211
  #define KW_BOOL 212
  #define KW_STRING 213
  #define KW_TRUE 214
  #define KW_FALSE 215
  #define KW_IF 216  
  #define KW_THEN 217
  #define KW_ELSE 218
  #define KW_FI 219
  #define KW_WHILE 220
  #define KW_LOOP 221
  #define KW_POOL 222
  #define KW_CONST 223
  #define KW_LET 224
  #define KW_RETURN 225
  #define KW_NOT 226
  #define KW_AND 227
  #define KW_OR 228
  #define KW_START 229

  //DEFINE OPERATORS
  #define OP_PLUS 270
  #define OP_MINUS 271
  #define OP_MUL 272
  #define OP_DIV 273
  #define OP_MOD 274
  #define OP_EQUALS 275
  #define OP_NOT_EQUALS 276
  #define OP_SMALLER 277
  #define OP_SMALLER_EQUALS 278
  #define OP_ASSIGN 279
  //ALSO ADDED ARROW OP
  #define OP_ARROW 280

  //DEFINE DELIMETERS
  #define DEL_SEMICOLON 300
  #define DEL_LEFT_PARENTESIS 301
  #define DEL_RIGHT_PARENTESIS 302
  #define DEL_COMMA 303
  #define DEL_LEFT_BRACKETS 304
  #define DEL_RIGHT_BRACKETS 305
  #define DEL_COLON 306
  //ADDED CURLY BRACKETS.NEEDED FOR FUNCTIONS
  #define DEL_LEFT_CURLY_BRACKETS 307
  #define DEL_RIGHT_CURLY_BRACKETS 308

  #include <math.h>
  int lineNum = 1;
%}

/*BOOL ("true"|"false")*/
ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  [+-]?{DIGIT}{DIGIT}*
DECIMAL ([+-]?"."{NUMBER})|([+-]?{NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING  \"(\\.|[^\\"])*\"

%x comment 
%x line_comment

%%

if          { printf("token KEYWORD_IF: %s", yytext); return KW_IF;};
else		    { printf("token KEYWORD_ELSE: %s", yytext); return KW_ELSE;};
then        { printf("token KEYWORD_THEN: %s", yytext); return KW_THEN;};
fi          { printf("token KEYWORD_FI: %s", yytext); return KW_FI;};
const       { printf("token KEYWORD_CONST: %s", yytext); return KW_CONST;};
start       { printf("token KEYWORD_START: %s", yytext); return KW_START;};
int         { printf("token KEYWORD_INT: %s", yytext); return KW_INT;};
string      { printf("token KEYWORD_STRING: %s", yytext); return KW_STRING;};

bool         { printf("token KEYWORD_BOOL: %s", yytext); return KW_BOOL;};
real         { printf("token KEYWORD_REAL: %s", yytext); return KW_REAL;};
let         { printf("token KEYWORD_LET: %s", yytext); return KW_LET;};
false        { printf("token KEYWORD_FALSE: %s", yytext); return KW_FALSE;};
true         { printf("token KEYWORD_TRUE: %s", yytext); return KW_TRUE;};
while         { printf("token KEYWORD_WHILE: %s", yytext); return KW_WHILE;};
loop         { printf("token KEYWORD_LOOP: %s", yytext); return KW_LOOP;};
pool         { printf("token KEYWORD_POOL: %s", yytext); return KW_POOL;};
return         { printf("token KEYWORD_RETURN: %s", yytext); return KW_RETURN;};
and         { printf("token OP_AND: %s", yytext); return KW_AND;};
or         { printf("token OP_OR: %s", yytext); return KW_OR;};
not         { printf("token OP_NOT: %s", yytext); return KW_NOT;};

{ID}        { printf("token IDENTIFIER: %s", yytext);return TK_IDENT; }
{NUMBER}    { printf("token NUMBER: %s", yytext); return TK_INT; }
{REAL}      { printf("A real: (%g) ", atof(yytext)); return TK_REAL; }
{STRING}    { printf("token STRING: %s", yytext); return TK_STRING; }

"<-"        { printf("token OP_ASSIGN: %s", yytext); return OP_ASSIGN;};

":"        { printf("token DEL_COLON: %s", yytext); return DEL_COLON;};
","        { printf("token DEL_COMMA: %s", yytext); return DEL_COMMA;};
";"        { printf("token DEL_SEMICOLON: %s", yytext); return DEL_SEMICOLON;};
"("        { printf("token DEL_LEFT_PARENTESIS: %s", yytext); return DEL_LEFT_PARENTESIS;};
")"        { printf("token DEL_RIGHT_PARENTESIS: %s", yytext); return DEL_RIGHT_PARENTESIS;};
"{"        { printf("token DEL_LEFT_CURLY_BRACKETS: %s", yytext); return DEL_LEFT_CURLY_BRACKETS;};
"}"        { printf("token DEL_RIGHT_CURLY_BRACKETS: %s", yytext); return DEL_RIGHT_CURLY_BRACKETS;};
"["        { printf("token DEL_LEFT_BRACKETS: %s", yytext); return DEL_LEFT_BRACKETS;};
"]"        { printf("token DEL_RIGHT_BRACKETS: %s", yytext); return DEL_RIGHT_BRACKETS;};

"<="       { printf("token LESS_EQUAL : %s", yytext); return OP_SMALLER_EQUALS;};
"<"         { printf("token LESS : %s", yytext); return OP_SMALLER;};
"=>"       { printf("token OP_ARROW : %s", yytext); return OP_ARROW;};
"="       { printf("token OP_EQUALS : %s", yytext); return OP_EQUALS;};
"!="       { printf("token OP_NOT_EQUALS : %s", yytext); return OP_NOT_EQUALS;};
"+"       { printf("token OP_PLUS : %s", yytext); return OP_PLUS;};
"-"       { printf("token OP_MINUS : %s", yytext); return OP_MINUS;};
"*"       { printf("token OP_MUL : %s", yytext); return OP_MUL;};
"/"       { printf("token OP_DIV : %s", yytext); return OP_DIV;};
"%"       { printf("token OP_MOD : %s", yytext); return OP_MOD;};

"--"         {BEGIN(line_comment); printf("One line comment is at line: %d\n", lineNum); }
<line_comment>[^\n]*    /*Eat all one line comments*/
<line_comment>\n {++lineNum;BEGIN(INITIAL);}

"(*"                    { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*)\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++lineNum;
<comment>"*"+")"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }

[ \r\t]+    /* skip whitespace and return on start */
\n 					 ++lineNum;
<<EOF>> 	return EOF; /*Marks End of file*/
.           { printf(ANSI_COLOR_RED "Line %d Lexical Error: Unrecognized literal %s\n" ANSI_COLOR_RESET, lineNum, yytext); exit(-10);}

%%
int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("\tLine %d Token %d: %s\n", lineNum, token, yytext);

  printf(ANSI_COLOR_GREEN "Your program is syntactically correct\n" ANSI_COLOR_RESET);
}





