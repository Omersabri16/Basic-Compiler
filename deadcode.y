%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <string>
#include <algorithm>
#include <set>
#include <iostream>
using namespace std;

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

struct Statement {
    string var;
    string expr;
    string original;
};

vector<Statement> statements;
vector<string> live_vars;
vector<string> final_output;

%}

%union {
    char *str;
}

%token <str> VAR NUMBER
%token PLUS MINUS TIMES DIVIDE POWER
%token ASSIGN SEMICOLON LBRACE RBRACE COMMA

%type <str> expr

%%

program: 
    statements live_set
    {
        //dead code elimination
        vector<Statement> reversed_statements = statements;
        reverse(reversed_statements.begin(), reversed_statements.end());
        
        set<string> live_set(live_vars.begin(), live_vars.end());
        vector<string> reversed_output;
        
        // reverse code
        for(const auto& stmt : reversed_statements) {
            if(live_set.find(stmt.var) != live_set.end()) {
                reversed_output.push_back(stmt.original);
                live_set.erase(stmt.var);
                
                // adding source variables to live set
                string current;
                for(char c : stmt.expr) {
                    if(isalpha(c)) {
                        current += c;
                    } else if(!current.empty()) {
                        live_set.insert(current);
                        current.clear();
                    }
                }
                if(!current.empty()) {
                    live_set.insert(current);
                }
            }
        }
        
        // reverse the output back
        reverse(reversed_output.begin(), reversed_output.end());
        
        // Print final optimized code
        for(const auto& stmt : reversed_output) {
            cout << stmt << endl;
        }
    }
    ;

statements: 
    statement
    | statements statement
    ;

statement: 
    VAR ASSIGN expr SEMICOLON
    {
        Statement stmt;
        stmt.var = $1;
        stmt.expr = $3;
        stmt.original = string($1) + "=" + $3 + ";";
        statements.push_back(stmt);
        delete[] $1;
        delete[] $3;
    }
    ;

expr: 
    VAR { $$ = $1; }
    | NUMBER { $$ = $1; }
    | expr PLUS expr 
    { 
        string result = string($1) + "+" + $3;
        $$ = strdup(result.c_str());
        delete[] $1;
        delete[] $3;
    }
    | expr MINUS expr 
    { 
        string result = string($1) + "-" + $3;
        $$ = strdup(result.c_str());
        delete[] $1;
        delete[] $3;
    }
    | expr TIMES expr 
    { 
        string result = string($1) +"*" +$3;
        $$ = strdup(result.c_str());
        delete[] $1;
        delete[] $3;
    }
    | expr DIVIDE expr 
    { 
        string result =string($1) +"/" +$3;
        $$ = strdup(result.c_str());
        delete[] $1;
        delete[] $3;
    }
    | expr POWER expr 
    { 
        string result=string($1) +"^" + $3;
        $$ = strdup(result.c_str());
        delete[] $1;
        delete[] $3;
    }

    ;

live_set:
    LBRACE live_vars_list RBRACE
    ;

live_vars_list:
    VAR 
    { 
        live_vars.push_back($1);
        delete[] $1;
    }
    | live_vars_list COMMA VAR
    { 
        live_vars.push_back($3);
        delete[] $3;
    }
    ;

%%

void yyerror(const char *s) {
    cerr << "Error: " << s << endl;
}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        cerr << "Usage: " << argv[0] << " <input_file>" << endl;
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if(!yyin) {
        cerr << "Error: Cannot open file " << argv[1] << endl;
        return 1;
    }
    
    yyparse();
    fclose(yyin);
    
    return 0;
}