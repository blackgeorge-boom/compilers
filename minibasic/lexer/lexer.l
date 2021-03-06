%{
#define T_eof 0
#define T_for 1001
#define T_print 1002
#define T_let 1003
#define T_if 1004
#define T_then 1005
#define T_do 1006
#define T_begin 1007
#define T_end 1008
#define T_id 1009
#define T_const 1010
%}

L [a-z]
D [0-9]
W [ \t\r\n]

%%

"for"    { return T_for; }
"print"  { return T_print; }
"let"    { return T_let; }
"if"     { return T_if; }
"then"   { return T_then; }
"do"     { return T_do; }
"begin"  { return T_begin; }
"end"    { return T_end; }

[()=+\-*/%]   { return yytext[0]; }

\'.*\n        { /* nothing */ }

{L}      { return T_id; }
{D}+     { return T_const; }

{W}+     { /* nothing */ }

%%

int main () {
  int token;
  do {
    token = yylex();
    printf("token=%d, lexeme=\"%s\"\n", token, yytext);
  } while (token != T_eof);
  return 0;
}

