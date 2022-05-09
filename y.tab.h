/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PRINT = 258,
    RETURN = 259,
    TIP = 260,
    MAIN = 261,
    VECTOR = 262,
    CARACTER = 263,
    CARACTERE = 264,
    STRING = 265,
    NUMAR = 266,
    INTEGER = 267,
    STRUCT = 268,
    ATRIBUIRE = 269,
    MARE = 270,
    MIC = 271,
    DIFERIT = 272,
    EGAL = 273,
    PRODUS = 274,
    IMPARTIRE = 275,
    PLUS = 276,
    MINUS = 277,
    SI = 278,
    SAU = 279,
    IF = 280,
    ELSE = 281,
    FOR = 282,
    WHILE = 283,
    STRCPY = 284,
    STRCMP = 285,
    TRUE = 286,
    FALSE = 287,
    UMINUS = 288
  };
#endif
/* Tokens.  */
#define PRINT 258
#define RETURN 259
#define TIP 260
#define MAIN 261
#define VECTOR 262
#define CARACTER 263
#define CARACTERE 264
#define STRING 265
#define NUMAR 266
#define INTEGER 267
#define STRUCT 268
#define ATRIBUIRE 269
#define MARE 270
#define MIC 271
#define DIFERIT 272
#define EGAL 273
#define PRODUS 274
#define IMPARTIRE 275
#define PLUS 276
#define MINUS 277
#define SI 278
#define SAU 279
#define IF 280
#define ELSE 281
#define FOR 282
#define WHILE 283
#define STRCPY 284
#define STRCMP 285
#define TRUE 286
#define FALSE 287
#define UMINUS 288

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 32 "tema.y"

int intval;
float floatval;
char* strval;
struct nod* expr;

#line 130 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
