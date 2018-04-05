%{
#include "parser.h"
#define T_eof 0

int linenumber = 1;

void yyerror (const char *msg);
%}

L [a-z]
D [0-9]
W [ \t\r]

%%

"for"         { return T_for; }
"print"       { return T_print; }
"let"         { return T_let; }
"if"          { return T_if; }
"then"        { return T_then; }
"do"          { return T_do; }
"begin"       { return T_begin; }
"end"         { return T_end; }

[()=+\-*/%]   { return yytext[0]; }

\'.*\n        { linenumber++;  /* ignore comment */ }

{L}           { return T_id; }
{D}+          { return T_const; }
\n            { linenumber++;  /* ignore new lines */ }
{W}+          { /* ignore other white space */ }

.             { yyerror("illegal character"); }

%%

