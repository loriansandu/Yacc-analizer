%{
#include <stdio.h>
#include "y.tab.h"
%}


%option noyywrap

%%

"print" { return PRINT; }
"return" { return RETURN;}
"&&" { return SI; }
"if" { return IF; }
"else" {return ELSE; }
"while" { return WHILE; }
"for" { return FOR; }
"strcpy" { return STRCPY; }
"int"|"float"|"char"|"string"|"bool" { yylval.strval=strdup(yytext); return TIP; }
[a-zA-z][a-zA-Z0-9]*(\[[1-9][0-9]*\])+ { yylval.strval=strdup(yytext); return VECTOR; }
\'[a-zA-Z]\'  {yylval.strval=strdup(yytext); return CARACTER; }
\"[a-zA-Z][a-zA-Z]*\" {yylval.strval=strdup(yytext); return CARACTERE; }
"true" { return TRUE; }
"false" { return FALSE; }
0|[1-9][0-9]* { yylval.strval=strdup(yytext); return INTEGER;}
0|[0-9]*[.][0-9]+ { yylval.strval=strdup(yytext); return NUMAR;}
[_a-zA-z][_a-zA-Z0-9]* { yylval.strval=strdup(yytext); return STRING; }
("void"|"int")[ ]+main\(\) { return MAIN; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return PRODUS; }
"/" { return IMPARTIRE; }
"=" { return ATRIBUIRE; }
">" { return MARE; }
"<" { return MIC; }
"!=" { return DIFERIT; }
"==" { return EGAL; }
"||" { return SAU; }



[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

