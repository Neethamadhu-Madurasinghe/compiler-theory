%{
    #include <stdio.h>
    #include "calc.tab.h"
%}

digit [0-9]
id [a-z][a-z0-9]*

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

