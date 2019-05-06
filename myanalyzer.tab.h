/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_MYANALYZER_TAB_H_INCLUDED
# define YY_YY_MYANALYZER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_IDENT = 258,
    TK_INT = 259,
    TK_REAL = 260,
    TK_STRING = 261,
    KW_INT = 262,
    KW_REAL = 263,
    KW_BOOL = 264,
    KW_STRING = 265,
    KW_TRUE = 266,
    KW_FALSE = 267,
    KW_IF = 268,
    KW_THEN = 269,
    KW_ELSE = 270,
    KW_FI = 271,
    KW_WHILE = 272,
    KW_LOOP = 273,
    KW_POOL = 274,
    KW_CONST = 275,
    KW_LET = 276,
    KW_RETURN = 277,
    KW_AND = 278,
    KW_OR = 279,
    KW_START = 280,
    KW_NOT = 281,
    OP_PLUS = 282,
    OP_MINUS = 283,
    OP_MUL = 284,
    OP_DIV = 285,
    OP_MOD = 286,
    OP_EQUALS = 287,
    OP_NOT_EQUALS = 288,
    OP_SMALLER = 289,
    OP_SMALLER_EQUALS = 290,
    OP_ASSIGN = 291,
    OP_ARROW = 292,
    DEL_SEMICOLON = 293,
    DEL_LEFT_PARENTESIS = 294,
    DEL_RIGHT_PARENTESIS = 295,
    DEL_COMMA = 296,
    DEL_LEFT_BRACKETS = 297,
    DEL_RIGHT_BRACKETS = 298,
    DEL_COLON = 299,
    DEL_LEFT_CURLY_BRACKETS = 300,
    DEL_RIGHT_CURLY_BRACKETS = 301
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 12 "myanalyzer.y" /* yacc.c:1909  */

  char* crepr;

#line 105 "myanalyzer.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_MYANALYZER_TAB_H_INCLUDED  */
