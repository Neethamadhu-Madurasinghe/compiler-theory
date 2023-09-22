%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror(char *);
void yy_scan_string(char *);
void addSymbol(char [], int);
void printSymbolTable();

extern FILE* yyin;
extern int yylineno;

struct symbolTableEntry* findSymbol(char *);

/*
    Symbol table entry - Symbol table is a linked list
    name - identifier 
    address - memory location where the data is stored
    type - indicates data type of the variable : int (0) or float (1)
    isInit - indicates whether the variable is initialized or not
 */
struct symbolTableEntry{
    char *name;
    void *address;
    int type;
    int isInit;
    struct symbolTableEntry* next;
};

struct symbolTableEntry* head = NULL;
%}

/* Terminal symbols */

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_INT TOK_FLOAT TOK_PRINTVAR 
%token TOK_OPENBRACKET TOK_CLOSEBRACKET TOK_OPENCURLYBRACKET TOK_CLOSECURLYBRACKET 
%token TOK_ID TOK_EQ TOK_TYPEINT TOK_TYPEFLOAT TOK_MAIN


/*
All possible types - 
Data struct stores the data and type of value for non-terminals
str stores the identifier names (Variable names)
intType and floatType is used save the value of TOK_INT and TOK_FLOAT
*/

%union{
 struct Data{
    int intVal;
    float floatVal;
    int type;
}data;
 char str[50];
 int intType;
 float floatType;
}

/* Type definitions of Terminal and Non-terminal symbols */
%type <intType> TOK_INT
%type <floatType> TOK_FLOAT
%type <str> TOK_ID
%type <data> expr

/* Left associative */
%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%
prog: TOK_MAIN TOK_OPENBRACKET TOK_CLOSEBRACKET TOK_OPENCURLYBRACKET stmts TOK_CLOSECURLYBRACKET;

stmts:
    | stmt TOK_SEMICOLON stmts;

stmt:
/* Make an entry in symbol table when there are statements like int x, float y etc.*/
    TOK_TYPEINT TOK_ID {
        addSymbol($2, 0);
    }
    | TOK_TYPEFLOAT TOK_ID
    {
        addSymbol($2, 1);
    }
     /* Assign a value to a variable, after checking whther the variable (identifier) exists in the symbol table */
    | TOK_ID TOK_EQ expr 
    {
        struct symbolTableEntry *entry = findSymbol($1);

        if(entry == NULL){
            // printError(sprintf("%s is used but is not declared", $1));
            printf("Line %d: %s is used but is not declared\n", yylineno, $1);
            YYABORT;

        }else{
            if (entry->type == 0 && $3.type == 0) {
                *(int *) entry->address = $3.intVal;
                entry->isInit = 1;

            } else if (entry->type == 1 && $3.type == 1) {
                *(float *) entry->address = $3.floatVal;
                entry->isInit = 1;

            } else {
                printf("Line %d: Types of symbol %s and given value do not match\n", yylineno, $1);
                YYABORT;
            }
        }
    }
    /* Print the value of an identifier when printvar <name> is matched, after checking whether the identifier exists and is initialized */
    | TOK_PRINTVAR TOK_ID  { 
        struct symbolTableEntry *entry = findSymbol($2);

        if(entry == NULL){
            printf("Line %d: %s is used but is not declared\n", yylineno, $2);
            YYABORT;

        }else{
            if(entry->isInit == 0){
                printf("Line %d: %s is used but is not initialized\n", yylineno, $2);
                YYABORT;
            }
            if (entry->type == 0) {
                printf("%d\n", *(int*)(entry->address));
            } else if (entry->type == 1) {
                printf("%f\n", *(float*)(entry->address));
            }
        }
    };

/* Copy value of terminal symbols, other expressions and id to expression */
/* $$ - Value of LHS in production rule,  $x (x = 1,2,3....) Values of symbols in RHS */
expr:
    /* Type cast and assign values of literals to expr (Expression) This should match with the union defined at the top */
    TOK_INT {
        $$ = (struct Data){ .type = 0, .intVal = $1 }; 
    }
    | TOK_FLOAT {
        $$ = (struct Data){ .type = 1, .floatVal = $1 };
    }
    /* Type cast and assign values of identifiers to expr (Expression), after checking the existence, initialization and type */
    | TOK_ID {
        struct symbolTableEntry *entry = findSymbol($1);

        if(entry == NULL){
            printf("Line %d: %s is used but is not declared\n", yylineno, $1);
            YYABORT;
        }else{
            if(entry->isInit == 0){
                printf("Line %d: %s is used but is not initialized\n", yylineno, $1);
                YYABORT;
            }
            
            if (entry->type == 0) {
                $$ = (struct Data){ .type = 0, .intVal = *(int*)(entry->address) };
            } else if (entry->type == 1) {
                $$ = (struct Data){ .type = 1, .floatVal = *(float*)(entry->address) };
            }
        }
    }
    /* Add values of two expressions and store the value, after checking the existance, initialization and type */
    | expr TOK_ADD expr {
        if($1.type == $3.type) {
            if($1.type == 0) {
                $$ = (struct Data){ .type = 0, .intVal = ($1.intVal) + ($3.intVal)};
            } else if($1.type == 1) {
                $$ = (struct Data){ .type = 1, .floatVal = ($1.floatVal) + ($3.floatVal)};
            }
    
        } else {
            printf("Line %d: Values are not of the same type\n", yylineno);
            YYABORT;
        }
        
    }
    /* Multiply values of two expressions and store the value, after checking the existance, initialization and type */
    | expr TOK_MUL expr {
        if($1.type == $3.type) {
            if($1.type == 0) {
                $$ = (struct Data){ .type = 0, .intVal = ($1.intVal) * ($3.intVal)};
            } else if($1.type == 1) {
                $$ = (struct Data){ .type = 1, .floatVal = ($1.floatVal) * ($3.floatVal)};
            }
    
        } else {
            printf("Line %d: Values are not of the same type\n", yylineno);
        }
    }

%%
int yyerror(char *s) {
fprintf(stderr, "Line %d: Syntax error\n", yylineno);
return 0; }

/* Function to find whether a symbol entry with a given identifier name exists in the symbol table*/
struct symbolTableEntry* findSymbol(char *name){
    struct symbolTableEntry* current = head;
    while(current != NULL){
        if(strcmp(current->name, name) == 0){
            return current;
        }
        current = current->next;
    }
    return NULL;
}

/* Function to add a symbol entry to the symbol table for variables (if it does not exist already) */
void addSymbol(char name[50], int type) {
    if(findSymbol(name) != NULL){
        printf("Line %d: Symbol %s already exists\n", yylineno, name);
        return;
    }

    struct symbolTableEntry* newEntry = (struct symbolTableEntry*) malloc(sizeof(struct symbolTableEntry));
    newEntry->name = name;
    newEntry->type = type;
    newEntry->isInit = 0;
    newEntry->next = head;

    if(type == 0){
        newEntry->address = (int*) malloc(sizeof(int));
    }else if(type == 1){
        newEntry->address = (float*) malloc(sizeof(float));
    }
    head = newEntry;
}

/* For debugging purposes */
void printSymbolTable() {
    struct symbolTableEntry* current = head;
    while(current != NULL){
        if(current->type == 0) {
            printf("int %s - %d\n", current->name,  *(int*)(current->address));
        } else if(current->type == 1) {
            printf("float %s - %f\n", current->name,  *(float*)(current->address));
        }
        current = current->next;
    }
}

int main(int argc, char* argv[]){

     if (argc == 0) {
        fprintf(stderr, "Usage: %s input_file\n", argv[0]);
        return 1;
    }

    /* Read from file and parse according to the grammar rules specified  */
    yyin = stdin;
    yyparse();

    fclose(yyin);
    return 0;
}

