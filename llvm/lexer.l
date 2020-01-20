%{
#include <string.h>
#include "ast.h"
#include "parser.hpp"
#define T_eof 0

void yyerror (const char *msg);
void debug (const char *msg);

char escape_char(char c);
int hex_char_to_int(char c);
char escape_hex(char least, char most);
char* escape_string(char* text);

int comment_nesting = 0;  
int line_number = 1;
int current_line_indent = 0;
int temp = 0;
int indent_level = 0;
int indent_mode_flag = 0;	
int command_line_flag = 0;	
int boom = 0;

struct stack_t {			
	int top, flag;			
	struct stack_t *next;
};
typedef struct stack_t *stack;

struct stack_t *l = NULL, *t;

%}

L[A-Za-z]
D[0-9]
W[ \t\r]
E[\\\'\"]
X[trn0]
S[+\-*\/%!&\|=<>]
Q[()\[\]\,:]
R[`~@#$^_\{\}\;?.]

%x SC_COMMENT
%x ONE_LINE_COMMENT
%x INDENT

%%

"(*"   		     { BEGIN(SC_COMMENT); }
<SC_COMMENT>{
  "(*"           { ++comment_nesting; }
  "*"+")"        {	if (comment_nesting) --comment_nesting;
                 	else 
                 		if (indent_mode_flag == 0)
                 			BEGIN(INITIAL);
                 		else
                 			BEGIN(INDENT);
                 }
  "*"+           ; 
  [^(*\n]+  	 ; 
  [()]           ; 
  \n             { line_number++; }
}

"#"				{ BEGIN(ONE_LINE_COMMENT); }
<ONE_LINE_COMMENT>{
	[^\n]+	;
	\n    	{ 	      line_number++;
					  current_line_indent = 0;
					  if (command_line_flag) 
					  	BEGIN(INDENT);
					  else 
					  	BEGIN(INITIAL);
			}  
}

<INDENT>"(*"	{ BEGIN(SC_COMMENT); }
<INDENT>" "		{ current_line_indent++; }
<INDENT>"\t"	{ current_line_indent = (current_line_indent + 8) & ~7; }
<INDENT>"#"		{ BEGIN(ONE_LINE_COMMENT); }
<INDENT>"\n"	{ current_line_indent = 0; line_number++; /*ignoring blank line*/}
<INDENT>.		{
					unput(*yytext);						//put the lexeme back to input stream and return its token later
												//we now care only for the indenting tokens (begin-end)

					if (l != NULL) temp = l->top;				//temp = the top of the stack
					else temp = 0;					

					if (current_line_indent > temp){			//if we are right of temp, then a new block begins
						indent_level++;					//and is pushed to the stack
						t = (struct stack_t *)malloc(sizeof(struct stack_t));
						t->top = current_line_indent;
						t->flag = 0;
						t->next = l;
						if (l != NULL) {
							l->flag = 1;				//previous block is non-empty now, so set its flag to 1
						}
						l = t;
						indent_mode_flag = 1;
						return T_begin;					//we produce a begin token
					}
					else if (current_line_indent < temp) {			//if we are left of the driver of the most internal
												//block we need to close the block (if it was non-empty)
												//and remove it from the stack
						t = l;
						if (t != NULL) {
							l = l->next;				//next outer block
							
							if (current_line_indent > l->top){	//we need to check if we are also to the left of the driver
												//of the next outer block. If so, we continue to <INDENT>
												//to check if we can close the outer block, else we go to
												//<INITIAL>
								indent_mode_flag = 0;
								BEGIN(INITIAL);
							}
							else{
								BEGIN(INDENT);
							}
							if (t->flag == 1){			//if this was a non empty block, we need to 
								indent_level--;			//close it, reducing the depth of indentation
								free(t);			//remove from stack
								return T_end;			//and producing a T_end
							}
							else{
								free(t);			//remove from stack
							}
				
						}
					}
					else {							//else we are exactly at the column of temp
						t = l;
						if (t != NULL) {
							indent_mode_flag = 0;	
							BEGIN(INITIAL);
							if (t->flag == 1){			//if the block was non empty, we don't remove
												//the block from the stack, because the driver that just closed it
												//may begin a new block later, in the same depth of indentation
								indent_level--;			//so, we only close the block reducing the depth of indentation
								t->flag = 0;			//reseting the flag
								return T_end;			//and producing an end-token
							}
						}
					}
				}


<<EOF>>		 	{
					
					if (indent_level != 0){
						if(l != NULL){
							t = l;		
							indent_level--;	
							l = l->next;
							free(t);
							return T_end ;
						}
						else {
							return T_eof ;
						}
					}
					else{
						return T_eof;
					}

				}

"and"        { return T_and; }
"as"         { return T_as; }
"begin"      { if(command_line_flag == 1)
					yyerror("begin token?");
			   else
					return T_begin; 
			 }
"break"      { return T_break; }
"byte"       { return T_byte; }
"continue"   { return T_continue; }
"decl"       { return T_decl; }
"def"        { return T_def; }
"elif"       { return T_elif; }
"else"       { return T_else; }
"end"      	 { if(command_line_flag == 1)
					yyerror("end token?");
			   else
					return T_end; 
			 }
"exit"       { return T_exit; }
"false"      { return T_false; }
"if" 		 { return T_if; }
"is"         { return T_is; }
"int"        { return T_int; }
"loop"       { return T_loop; }
"not"        { return T_not; }
"or"         { return T_or; }
"ref"        { return T_ref; }
"return"     { return T_return; }
"skip"       { return T_skip; }
"true"       { return T_true; }
"var"        { return T_var; }
"<>"         { return T_neq; }
"<="         { return T_leq; }
">="         { return T_geq; }
":="         { return T_assgn; }



{S}          { return yytext[0]; }
{Q}          { return yytext[0]; }

({L})({L}|{D}|"_")*     { yylval.s = strdup(yytext); return T_id; }
{D}+            { yylval.n = atoi(yytext); return T_const; }
\'({D}|{L})\' { yylval.n = yytext[1]; return T_char; }

\'("\\"[ntr0"\"\'""""\\"])\'    {
                                    yylval.n = escape_char(yytext[2]);
                                    return T_char;
                                }
\'("\\"[x]({D}|[a-f]|[A-F])({D}|[a-f]|[A-F]))\' {
                                                    char most_significant = yytext[3];
                                                    char least_significant = yytext[4];
                                                    yylval.n = escape_hex(most_significant, least_significant);
                                                    return T_char;
                                                }
\'[ ]\'		{ yylval.n = yytext[1]; return T_char; }

\"(({S}|{Q}|{L}|{R}|{D}|("\\"{E})|("\\"{X})|("\\"[x]({D}|[a-f]|[A-F])({D}|[a-f]|[A-F])|" "))+)\" {
    yytext[strlen(yytext) - 1] = '\0';      // replaces final \"
    yylval.s = escape_string(yytext + 1);   // dumps starting \" and replaces escape sequences
    return T_str;
}

\"\"				{ std::string temp = "\0"; strcpy(yylval.s, temp.c_str()); return T_str; }
{W}+                { /* nothing */ }
\n                  { line_number++; current_line_indent = 0; if (command_line_flag) BEGIN(INDENT); }
.                   { yyerror("Unknown word in a line"); }


%%

char escape_char(char c)
{
    switch (c) {
        case 'n':
            return '\n';
        case 'r':
            return '\r';
        case 't':
            return '\t';
        case '0':
            return '\0';
        case '\'':
            return '\'';
        case '\"':
            return '\"';
        case '\\':
            return '\\';
        default:
            yyerror("Wrong case with escape char...");
    }
}

int hex_char_to_int(char c)
{
    if (c >= '0' && c <= '9')
        return c - '0';
    else if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    else if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    else
        error("Wrong char at hex digit");
}

char escape_hex(char most, char least)
{
    return 16 * hex_char_to_int(most) + hex_char_to_int(least);
}

char* escape_string(char* text)
{
    char* fixed_string = (char *)malloc((strlen(text) + 1) * sizeof(char));
    int i = 0;
    int j = 0;

    while (text[i] != '\0') {
        if (text[i] == '\\') {
            i++;
            if (text[i] == 'x') {
                fixed_string[j] = escape_hex(text[i + 1], text[i + 2]);
                i += 2;
            }
            else
                fixed_string[j] = escape_char(text[i]);
        }
        else
            fixed_string[j] = text[i];
        i++;
        j++;
    }
    return fixed_string;
}
