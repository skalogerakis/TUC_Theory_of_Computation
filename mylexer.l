%{
  //All defines needed are here.Maybe check if can be used in external file.


  #define TK_IDENT 258
  #define TK_INT 259
  #define TK_REAL 260
  #define TK_ASSGN 261
  #define KW_IF 262  
  #define KW_ELSE 263
  
  #include <math.h>
  int lineNum = 1;
%}


ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  [+-]?{DIGIT}{DIGIT}*
DECIMAL ([+-]?"."{NUMBER})|([+-]?{NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?

%x comment 

%%

if          { printf("token KEYWORD_IF: %s", yytext); return KW_IF;};
else		    { printf("token KEYWORD_ELSE: %s", yytext); return KW_ELSE;};

{ID}        { return TK_IDENT; }
{NUMBER}    { return TK_INT; }
{REAL}      { printf("A real: (%g) ", atof(yytext)); return TK_REAL; }

"+"         printf("An operator "); return '+';
"-"         printf("An operator "); return '-';
"*"         printf("An operator "); return '*';
"/"         printf("An operator "); return '/';
"("					return '(';
")"					return ')';

"//"[^\n]*  printf("Line %d: line comment: %s\n", lineNum, yytext);/* eat line comments */

":="        { return TK_ASSGN ;}

[ \r\t]+		/* skip whitespace */

"/*"                    { BEGIN(comment); printf("comment started at line: %d\n", lineNum); }
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++lineNum;
<comment>"*"+"/"        { BEGIN(INITIAL); printf("comment ended at line: %d\n", lineNum); }

\n 					 ++lineNum;

<<EOF>> 	return EOF;
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); }

%%
int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("\tLine %d Token %d: %s\n", lineNum, token, yytext);
      
   //while ( token != 0 )
    //  printf("\tLine %d Token %d: %s\n", lineNum, token, yytext);
}





