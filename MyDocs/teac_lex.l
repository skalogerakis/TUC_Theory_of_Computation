%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "teac_parser.tab.h"
#include "cgen.h"

int line_num = 1;

%}

IDENT [a-zA-Z_][0-9a-zA-Z_]*
DIGIT  [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING  '[^'\n]*'

%x comment

%%

start					return KW_START;
const 				return KW_CONST;
let						return KW_LET;
int           return KW_INT;
real          return KW_REAL;
string        return KW_STRING;

{IDENT}  	    { yylval.crepr = strdup(yytext); return IDENT; }


{NUMBER}			{ yylval.crepr = strdup(yytext); return POSINT; }
{REAL}				{ yylval.crepr = strdup(yytext); return REAL; }
{STRING}			{ yylval.crepr = strdup(yytext); return STRING; }

"<-"		      return ASSIGN;
"=>"         	return ARROW;
":"		        return ':';
","           return ',';
"+"						return '+';
"*"						return '*';
";"						return ';';
"."						return '.';
"("						return '(';
")"						return ')';

"["						return '[';
"]"						return ']';

"{"						return '{';
"}"						return '}';

"--"[^\n]*  	/* eat line comments */

"(*"					BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*)\n]*   /* eat up '*'s not followed by ')'s */
<comment>\n             ++line_num;
<comment>"*"+")"        BEGIN(INITIAL);


[ \r\t]				/* skip whitespace */
\n 						++line_num;
<<EOF>> 			return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%


