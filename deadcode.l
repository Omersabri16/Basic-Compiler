%{
#include "y.tab.h"
#include <string.h>
%}

%%

[ \t\n]+    ; /* white space atlamaca */
[a-zA-Z]    { yylval.str = strdup(yytext); return VAR; }
[0-9]+      { yylval.str = strdup(yytext); return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"^"         { return POWER; }
"="         { return ASSIGN; }
";"         { return SEMICOLON; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
","         { return COMMA; }

%%

int yywrap() {
    return 1;
}