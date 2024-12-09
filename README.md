# numericalintegration-haskell-c-
calculus with haskell/c++
Numerical Integration Calculator (Haskell)
Overview
This is a numerical integration calculator implemented in Haskell using Simpson's Rule. The program allows users to numerically integrate various mathematical functions by specifying integration limits and the number of sub-intervals.
Features

Numerical integration using Simpson's Rule
Multiple pre-defined integration functions
Interactive command-line interface
Error handling for invalid inputs
Supports various mathematical functions

Prerequisites
Glasgow Haskell Compiler (GHC) 8.10 or later
Haskell Platform (recommended)

Compilation Instructions
Compile with GHC
bashCopyghc -O2 simpsons.hs
Run the Executable
bashCopy./simpsons
alternative: run on available online compiler ||https://www.onlinegdb.com/online_haskell_compiler||

execution outlook:
Simpson's Rule Numerical Integration
Available Functions:
Select function (1-4): 2
Enter lower limit (a): 1
Enter upper limit (b): 2
Enter number of sub-intervals (must be even): 10
Numerical Integration of f(x) = 1/x from 1.00 to 2.00: 0.693150
Do another integration? (y/n): Killed

Error Handling
Validates integration limits
sub-intervals are even
Provides meaningful error messages on violation of second condition

Language: Haskell
Compiler: GHC
Key Libraries/imports:
Text.Printf
Control.Exception
