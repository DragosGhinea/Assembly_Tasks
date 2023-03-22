# Tasks made in Assembly x86 (AT&T)

These tasks have been made for the course of *Computer Architecture* held by Conf. Dr. Cristian Rusu in 2021.

## task1.asm

Given a hexadecimal string as input, the task is to display the corresponding assembly instruction to be executed on the standard output.

For example, for the input A78801C00A7890EC04, the output on the standard output will be x 1 let x -14 div.

A 12 bits array is read as follows:
  - a safety bit, set to 1
  - 2 bits meaning an identifier
      - 00 = integer
      - 01 = variable
      - 10 = instruction
  - 9 bits meaning the information stored

## task2.asm

Given an instruction in the assembly language of the considered arithmetic processor as input, the task is to display the evaluation of the instruction on the standard output. For this requirement, there are no variables in the instruction, which is composed only of integers and operations.

Example: 2 10 mul 5 div 7 6 sub add = 5

## task3.asm

Given an instruction in the assembly language of the considered arithmetic processor as input, the task is to display the evaluation of the instruction on the standard output. For this requirement, unlike requirement 2, variables introduced with the "let" keyword are used.

Example: x 1 let 2 x add y 3 let x y add mul = 12

## task4.asm

For this requirement, we will introduce simple matrix operations. A matrix can be represented in the form of: number of rows number of columns number of rows * number of columns elements

The operations that can be used on matrices are:
 - add - we add the operand value to all elements of the matrix;
 - sub - we subtract the operand value from all elements of the matrix;
 - mul - we multiply all elements of the matrix by the operand value;
 - div - we divide all elements of the matrix by the operand value;
 - rot90d - we rotate the matrix 90 degrees to the right;

Matrix operations only contain the "let" instruction and one of the previously mentioned operations. There are no complex instructions, as in the previous requirements!

## task5.asm

We read from the keyboard n, m, and 3 · n elements that can be 0 or between 1 and n, where the condition 1 ≤ n, m ≤ 30 is met. The smallest lexicographically permutation of the set {1, ..., n} will be generated, where each element appears exactly 3 times, with a minimum distance of m elements between any two equal elements, starting from certain already specified fixed points.

For example, for n = 5, m = 1 and the sequence of 15 elements
1 0 0 0 0 0 3 0 0 0 0 0 0 4 5
each element from the set {1, 2, 3, 4, 5} appears 3 times, and we want at least m = 1 element distance between any two equal elements. Then, the smallest lexicographically permutation, keeping the fixed points, is the following:
1 2 1 2 1 2 3 4 3 5 3 4 5 4 5

Either the permutation, if it exists, will be displayed in the above format: the elements will be displayed with spaces between them on the screen, and at the end, we recommend to use a newline character instead of using fflush; or -1, if there is no permutation that satisfies all the conditions, will be displayed at the standard output, depending on the case.

## task6.asm

A **9 × 9 Sudoku** puzzle is read from a text file, with elements from the set {0, 1, ..., 9}, where 0 indicates that the respective box has no completed value. Write an algorithm that solves this puzzle, finding the first solution in lexicographic order (where the solution is not unique). The solved puzzle will be written to an output file.