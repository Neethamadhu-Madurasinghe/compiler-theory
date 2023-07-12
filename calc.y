%{
#include <stdio.h>
int yylex();
int yyerror(char *s);
void yy_scan_string(char *s);
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_INT TOK_FLOAT TOK_PRINTVAR TOK_OPENBRAKET TOK_CLOSENBRAKET TOK_OPENCURLBRAKET TOK_CLOSECURLBRAKET TOK_ID TOK_EQ TOK_TYPE TOK_MAIN


/*all possible types*/
%union{
int int_val;
float float_val;
int type;
char name[10];
}

%type <int_val> TOK_INT
%type <float_val> TOK_FLOAT

/*left associative*/
%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%
prog: TOK_MAIN TOK_OPENBRAKET TOK_CLOSECURLBRAKET TOK_OPENCURLBRAKET stmts TOK_CLOSECURLBRAKET;

stmts:

    | stmt TOK_SEMICOLON stmts;

stmt: 
    | TOK_TYPE TOK_ID 
    {
        
    }
    | TOK_ID TOK_EQ expr
    | TOK_PRINTVAR TOK_ID  { /** print the value **/ };

expr:
    intgr
    | flt
    | TOK_ID
    | TOK_ID TOK_ADD TOK_ID
    | TOK_ID TOK_MUL TOK_ID;

intgr: TOK_INT;

flt: TOK_FLOAT;

%%
int yyerror(char *s){
fprintf(stderr, "syntax error");
return 0; }

int main(int argc, char* argv[]){

    if (argc != 2) {
        fprintf(stderr, "Usage: %s \"expression\"\n", argv[0]);
        return 1;
    }

    yy_scan_string(argv[1]);
    yyparse();
    return 0;
}

