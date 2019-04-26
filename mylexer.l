%{
  //All defines needed are here.Maybe check if can be used in external file.


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
  #define OP_ADD 270
  #define OP_SUB 271
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
STRING "[^'\n]*"

%x comment 
%x line_comment

%%

if          { printf("token KEYWORD_IF: %s", yytext); return KW_IF;};
else		    { printf("token KEYWORD_ELSE: %s", yytext); return KW_ELSE;};
const       { printf("token KEYWORD_CONST: %s", yytext); return KW_CONST;};
start       { printf("token KEYWORD_START: %s", yytext); return KW_START;};
string      { printf("token KEYWORD_STRING: %s", yytext); return KW_STRING;};
int         { printf("token KEYWORD_INT: %s", yytext); return KW_INT;};

{ID}        { printf("token IDENTIFIER: %s", yytext);return TK_IDENT; }
{NUMBER}    { printf("token NUMBER: %s", yytext); return TK_INT; }
{REAL}      { printf("A real: (%g) ", atof(yytext)); return TK_REAL; }
{STRING}    { printf("token STRING: %s", yytext); return TK_STRING; }

"<-"        { printf("token OP_ASSIGN: %s", yytext); return OP_ASSIGN;};

":"        { printf("token DEL_COLON: %s", yytext); return DEL_COLON;};
";"        { printf("token DEL_SEMICOLON: %s", yytext); return DEL_SEMICOLON;};
"("        { printf("token DEL_LEFT_PARENTESIS: %s", yytext); return DEL_LEFT_PARENTESIS;};
")"        { printf("token DEL_RIGHT_PARENTESIS: %s", yytext); return DEL_RIGHT_PARENTESIS;};
"{"        { printf("token DEL_LEFT_CURLY_BRACKETS: %s", yytext); return DEL_LEFT_CURLY_BRACKETS;};
"}"        { printf("token DEL_RIGHT_CURLY_BRACKETS: %s", yytext); return DEL_RIGHT_CURLY_BRACKETS;};
"<="       { printf("token LESS_EQUAL : %s", yytext); return OP_SMALLER_EQUALS;};
"<"         { printf("token LESS : %s", yytext); return OP_SMALLER;};
"=>"       { printf("token OP_ARROW : %s", yytext); return OP_ARROW;};

"--"          BEGIN(line_comment);
<line_comment>[^\n]*    /*Eat all one line comments*/
<line_comment>\n BEGIN(INITIAL);

"(*"                    { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*)\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++lineNum;
<comment>"*"+")"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }

[ \r\t]+    /* skip whitespace */
\n 					 ++lineNum;
<<EOF>> 	return EOF; /*Marks End of file*/
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); }

%%
int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("\tLine %d Token %d: %s\n", lineNum, token, yytext);

}





