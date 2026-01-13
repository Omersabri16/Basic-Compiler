📘 Dead Code Elimination using Lex & Yacc

This project implements a simple compiler front-end that performs dead code elimination on an intermediate language (IL) using Lex and Yacc.
The program reads assignment statements, parses expressions, identifies live variables, and removes all statements that do not contribute to the final live set.

🚀 Features

Lex-based tokenizer for variables, numbers, operators, and punctuation

Yacc-based parser with full grammar rules

Extraction and storage of:

left-hand variable

right-hand expression

original statement text

live variable set

Backward liveness analysis

Removal of unreachable or unnecessary code

Output of a fully optimized IL program

📄 Input Format

The input consists of:

A sequence of assignment statements:

a=2+2;
b=2^9;
r=e*p;
s=a;


A final set of live variables inside braces:

{ r, s }

🧠 Dead Code Elimination Logic

The program applies backward liveness analysis:

Reverse the list of statements

Start with the initial live set

For each statement:

If the left-hand variable is live → keep the statement

Add all variables used in its expression to the live set

Reverse and print the kept statements in original order

🛠️ How to Build

The project includes a Makefile.

Compile with:

make


This generates the executable:

deadcode

▶️ How to Run

Provide an input file:

./deadcode input.txt


Example input:

a=2+2;
b=2^9;
c=d^3;
e=5;
p=0;
r=e*p;
s=a;
{ r, s }


Example output:

a=2+2;
e=5;
p=0;
r=e*p;
s=a;
