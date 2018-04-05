%{
#include "ast.h"
#include "parser.h"
#define T_eof 0

int linenumber = 1;

void yyerror (const char *msg);
%}

L [a-z]
D [0-9]
W [ \t\r]

%%

"for"          { return T_for; }
"print"        { return T_print; }
"let"          { return T_let; }
"if"           { return T_if; }
"then"         { return T_then; }
"do"           { return T_do; }
"begin"        { return T_begin; }
"end"          { return T_end; }
"var"          { return T_var; }
"int"          { return T_int; }
"bool"         { return T_bool; }
"and"          { return T_and; }
"or"           { return T_or; }
"not"          { return T_not; }

[()=+\-*/%<>:] { return yytext[0]; }

"<="           { return T_le; }
">="           { return T_ge; }
"<>"           { return T_ne; }

\'.*\n         { linenumber++;  /* ignore comment */ }

{L}            { yylval.c = yytext[0]; return T_id; }
{D}+           { yylval.n = atoi(yytext); return T_const; }
\n             { linenumber++;  /* ignore new lines */ }
{W}+           { /* ignore other white space */ }

.              { yyerror("illegal character"); }

%%

