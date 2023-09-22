%option yylineno
yylineno = 1;

%{
    #include <stdio.h>
    #include "calc.tab.h" // Include the generated header file from Bison
%}

/* Regular expression definitions */
digit [0-9]         
id [a-z][a-z0-9]*  
whitespace [ \n\t]  

%%
"printvar" { return(TOK_PRINTVAR);}
{digit}+ { sscanf(yytext, "%d", &(yylval.int_val));
yylval.int_val = 0;
return TOK_INT; }
({digit}*[.])?{digit}+ { sscanf(yytext, "%f", &(yylval.float_val));
yylval.int_val = 1;
return TOK_FLOAT; }
{id} { sscanf(yytext, "%s", &(yylval.name)); return(TOK_ID); }
"int" { yylval.type = 0; return(TOK_TYPE);}
"float" { yylval.type = 1; return(TOK_TYPE); }
"main" { return(TOK_MAIN); }
";" { return(TOK_SEMICOLON); }
"+" { return(TOK_ADD); }
"-" { return(TOK_SUB); }
"*" { return(TOK_MUL); }
"/" { return(TOK_DIV); }
"=" { return(TOK_EQ); }
"(" { return(TOK_OPENBRAKET); }
")" { return(TOK_CLOSENBRAKET); }
"{" { return(TOK_OPENCURLBRAKET); }
"}" { return(TOK_CLOSECURLBRAKET); }
\n {}
. {printf("Invalid character '%c‘\n", yytext[0]);}
%%

"printvar" { return(TOK_PRINTVAR); }          /* Match the keyword "printvar" and return the corresponding token */
"int" { return(TOK_TYPEINT); }                /* Match the keyword "int" and return the corresponding token */
"float" { return(TOK_TYPEFLOAT); }            /* Match the keyword "float" and return the corresponding token */
"main" { return(TOK_MAIN); }                  /* Match the keyword "main" and return the corresponding token */
";" { return(TOK_SEMICOLON); }                /* Match the semicolon and return the corresponding token */
"+" { return(TOK_ADD); }                      /* Match the plus sign and return the corresponding token */
"-" { return(TOK_SUB); }                      /* Match the minus sign and return the corresponding token */
"*" { return(TOK_MUL); }                      /* Match the asterisk and return the corresponding token */
"/" { return(TOK_DIV); }                      /* Match the forward slash and return the corresponding token */
"=" { return(TOK_EQ); }                       /* Match the equal sign and return the corresponding token */
"(" { return(TOK_OPENBRACKET); }              /* Match the open parenthesis and return the corresponding token */
")" { return(TOK_CLOSEBRACKET); }             /* Match the close parenthesis and return the corresponding token */
"{" { return(TOK_OPENCURLYBRACKET); }         /* Match the open curly brace and return the corresponding token */
"}" { return(TOK_CLOSECURLYBRACKET); }        /* Match the close curly brace and return the corresponding token */

{digit}+ { sscanf(yytext, "%d", &(yylval.intType)); return TOK_INT; }                   /* Match an integer and store its value in yylval */
({digit}*[.])?{digit}+ { sscanf(yytext, "%f", &(yylval.floatType)); return TOK_FLOAT; } /* Match a float and store its value in yylval */
{id} { sscanf(yytext, "%s", yylval.str); return(TOK_ID); }                              /* Match an identifier and store its value in yylval */

{whitespace} {}    /* Ignore whitespace, do nothing when a whitespace character is encountered */
\n  { yylineno++; } /* Increment the line number when a newline character is encountered */

. { printf("Invalid character '%c'\n", yytext[0]); } /* Handle any other character not matched by previous rules */

%%