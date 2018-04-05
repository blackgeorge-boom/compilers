%{
#include "ast.h"
#include "parser.h"
#define T_eof 0

void yyerror (const char *msg);
void debug (const char *msg);

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

({L})({L}|{D}|"_")*     { return T_id; }
{D}+            { return T_const; }
\'({D}|{L}|"\\"[ntr0"\'""\""]|"\\"|("\\"[x]({D}|[a-f]|[A-F])({D}|[a-f]|[A-F])))\' {return T_char; }
\'[ ]\'		{ return T_char; }
\"(({S}|{Q}|{L}|{R}|{D}|("\\"{E})|("\\"{X})|("\\"[x]({D}|[a-f]|[A-F])({D}|[a-f]|[A-F])|" "))+)\" {return T_str; }
\"\"				{ return T_str; }     
{W}+                { /* nothing */ }
\n                  { line_number++; current_line_indent = 0; if (command_line_flag) BEGIN(INDENT); }
.                   { yyerror("Unknown word in a line"); }


%%
