000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. WRDSRT02.
000300*----------------------------------------------
000400* Accepts 2 words from the user and then displays
000500* them in ASCII order.
000600*----------------------------------------------
000700 ENVIRONMENT DIVISION.
000800 DATA DIVISION.
000900 WORKING-STORAGE SECTION.
001000
001100 01  WORD-1                 PIC X(50).
001200 01  WORD-2                 PIC X(50).
001300
001400 PROCEDURE DIVISION.
001500 PROGRAM-BEGIN.
001600
001700     PERFORM INITIALIZE-PROGRAM.
001800     PERFORM ENTER-THE-WORDS.
001900     PERFORM DISPLAY-THE-WORDS.
002000
002100 PROGRAM-DONE.
002200     STOP RUN.
002300
002400* Level 2 Routines
002500
002600 INITIALIZE-PROGRAM.
002700     MOVE " " TO WORD-1.
002800     MOVE " " TO WORD-2.
002900
003000 ENTER-THE-WORDS.
003100     DISPLAY "This program will accept 2 words,".
003200     DISPLAY "and then display them".
003300     DISPLAY "in ASCII order.".
003400
003500     DISPLAY "Please enter the first word.".
003600     ACCEPT WORD-1.
003700
003800     DISPLAY "Please enter the second word.".
003900     ACCEPT WORD-2.
004000
004100 DISPLAY-THE-WORDS.
004200
004300     DISPLAY "The words sorted in ASCII order are:".
004400
004500     IF WORD-1 < WORD-2
004600         DISPLAY WORD-1
004700         DISPLAY WORD-2.
004800
004900     IF WORD-1 NOT < WORD-2
005000         DISPLAY WORD-2
005100         DISPLAY WORD-1.
005200