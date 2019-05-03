%{
#define T_eof 0
#define T_and 1001
#define T_as 1002
#define T_begin 1003
#define T_break 1004
#define T_byte 1005
#define T_continue 1006
#define T_decl 1007
#define T_def 1008
#define T_elif 1009
#define T_else 1010
#define T_end 1011
#define T_exit 1012
#define T_false 1013
#define T_if 1014
#define T_is 1015
#define T_int 1016
#define T_loop 1017
#define T_not 1018
#define T_or 1019
#define T_ref 1020
#define T_return 1021
#define T_skip 1022
#define T_true 1023
#define T_var 1024
#define T_id 1025
#define T_const 1026
#define T_char 1027
#define T_str 1028
#define T_neq 1029
#define T_leq 1030
#define T_geq 1031
#define T_assgn 1032

#include <stdio.h>
#include <stdlib.h>

int comment_nesting = 0;  
int line_number = 1;
int current_line_indent = 0;	//this variable keeps the column where the current lexeme starts
int temp = 0;		
int indent_level = 0;		//the depth of indentation
int indent_mode_flag = 0;	//if it is set, we are in <INDENT> start condition
							//nested comments can begin during <INDENT> or <INITIAL>, so we need
							//to know where to return later, to <INDENT> or to <INITIAL>

int command_line_flag = 0;	//setting -i during execution will make the flag 1.
							//if the flag is one, offside rule is activated.

/*
 *	The top of the stack has the column of the first letter		
 *	of the driver of the most internal block. This doesn't 
 *	mean that the driver is followed by a non empty block. 
 *	It means that the driver is a lexeme which lies to the 
 *	right of the previous driver, so he may or may not be 
 *	followed by a non-empty block. If he is followed, the
 *	attribute "flag" will be set, from the next block.
 *	Else, it will remain zero.
 */

							
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
<INDENT>"\n"	{ current_line_indent = 0; line_number++;/*ignoring blank line*/}
<INDENT>.		{
					unput(*yytext);								//put the lexeme back to input stream and return its token later
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
							l->flag = 1;					//previous block is non-empty now, so set its flag to 1
						}
						l = t;
						indent_mode_flag = 1;
						return T_begin;						//we produce a begin token
					}
					else if (current_line_indent < temp) {				//if we are left of the driver of the most internal
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
							if (t->flag == 1){					//if this was a non empty block, we need to 
								indent_level--;					//close it, reducing the depth of indentation
								free(t);					//remove from stack
								return T_end;					//and producing a T_end
							}
							else{
								free(t);					//remove from stack
							}
				
						}
					}
					else {								//else we are exactly at the column of temp
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

"and"        { return T_and; }
"as"         { return T_as; }
"begin"      { if(command_line_flag == 1)	//"begin" keyword is not valid when offside-rule is activated
					printf("begin token? %d\n",line_number);
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
"end"      	 { if(command_line_flag == 1)	//"end" keyword is not valid when offside-rule is activated	
					printf("end token? %d\n",line_number);
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
\'[ ]\'	   	{ return T_char; }
\"(({S}|{Q}|{L}|{R}|{D}|("\\"{E})|("\\"{X})|("\\"[x]({D}|[a-f]|[A-F])({D}|[a-f]|[A-F])|" "))+)\"  {return T_str; }
\"\"				{ return T_str; }       
{W}+                { /* nothing */ }
\n                  { line_number++; current_line_indent = 0; if (command_line_flag) BEGIN(INDENT); }
.                   { printf("Unknown word in line %d\n",line_number); }



%%

/*	
 *	Makaris Nikolaos - 03113108
 *	Mavrogeorgis Nikolaos - 03113087
 *
 *	The lexer can scan either a whole input txt file, or continuously
 *	the input given in stdio. Input file must be specified in input arguments,
 *	else the default input is stdio. If -i switch is included, then offside 
 *	rule is activated. Default is the deactivated offside rule.
 *
 *	If offside rule is activated, we chose that when we recognise a block through
 *	indentation, to produce a "begin" and an "end" token, immediately before and
 *	immediately after the block respectively. We do not produce an "auto-end" token as the Dana grammar
 *	suggests. The resulting compiler should be equivalent.
 *
 */

int main (int argc, char **argv)
{
	int token, i, c;

	opterr = 0; 
	while((c = getopt(argc, argv, "i")) != -1) {
		if (c == 'i') {
			command_line_flag = 1;
			argc--;
			break;
		}
		else if (c == '?')
			break;
	}

	if (argc == 2)
		yyin = fopen(argv[command_line_flag + 1], "r");
	else if (argc == 1)
		yyin = stdin;
	else {
		printf("Usage: <lexer_executable> [-i] [input-file] \n");
		return 0;
	}

	l = (struct stack_t *)malloc(sizeof(struct stack_t));
	l->top = 0;
	l->flag = 0;
	l->next = NULL;

	token = yylex();
	while (token != T_eof){

		if (token == 1003)					//print "begin" lexeme exclusively
		printf("token = %4d, lexeme = begin\n", token);
		else if (token == 1011)					//print "begin" lexeme exclusively
		printf("token = %4d, lexeme = end\n", token);
		else 								
		printf("token = %4d, lexeme = %s\n", token, yytext);
		token = yylex();

	}

	token = 1011;
	for (i = 1; i <= indent_level; i++) {				//if indent_level is non-zero, there are 
		printf("token = %4d, lexeme = end\n", token);		//unclosed blocks. Close them, with #indent_level
		t = l;							//end-tokens.
		if(l != NULL){
			l = l->next;
			free(t);
		}
	}
	token = 0;
	printf("token = %4d, lexeme = EOF\n", token);		//End of file was reached.

	return 0;
}
