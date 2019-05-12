--AUTHOR: STEFANOS KALOGERAKIS
--AM: 2015030064
--TECHNICAL UNIVERSITY OF CRETE

***************************************************
Execute by following the automated procedure below:
***************************************************

1)Add input .tc file for testing in the folder ./InputTest which exists in current directory
2)Open a terminal the current directory which should include flex and bison files and a run bash file
2)Use ./run command to execute
3)Afterwards the terminal expects the file name you wish to process. ex. if your file is called test.tc then input will be test
4)Execution finishes with success or error

Bison file also produces an output file with c code when the procedure below is executed successfully.

Output file in c: bisonOUT.c

Execute output file as a c file

--gcc bisonOUT.c -o my_app
--./my_app