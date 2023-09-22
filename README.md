SCS-3211 | Compiler Theory
Assignment-1

Parser and Type Checker made using Flex and Bison for a simple programming language

M.A. Neethamadhu (20001223) - 2020cs122@stu.ucsc.cmb.ac.lk
S.R. Galappaththy (20000545) - 2020cs054@stu.ucsc.cmb.ac.lk

Testing:
Code was tested on:
    - Linux (WSL 1.2)
    - BSD Unix (MacOS 13.3)

How to execute (in a Unix / Linux environment):
1. Extract the .tar archive
2. Open a terminal and navigate to project directory
3. Run command: make
(Ensure you have make installed)
4. Run command: ./calc < input
(Ensure you have a file called 'input' with code in the project directory)


Special notes:
- The assignment was done on a Live Share enviornment, with real-time collaboration on all sections of the code by the two members
- The given test cases were tested with proper line breaks between statements
- On MacOS, we encountered an error (ld: library not found for -lfl), therefore -ll was used instead of -lfl when running gcc (in Makefile)