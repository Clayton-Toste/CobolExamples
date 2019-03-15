000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. SLSGEN01.
000300*---------------------------------
000400* Generate test sales data
000500*---------------------------------
000600 ENVIRONMENT DIVISION.
000700 INPUT-OUTPUT SECTION.
000800 FILE-CONTROL.
000900
001000*---------------------------------
001100* SLSALES.CBL
001200*---------------------------------
001300     SELECT SALES-FILE
001400         ASSIGN TO "SALES"
001500         ORGANIZATION IS SEQUENTIAL.
001600
001700 DATA DIVISION.
001800 FILE SECTION.
001900
002000*---------------------------------
002100* FDSALES.CBL
002200* Temporary daily sales file.
002300*---------------------------------
002400 FD  SALES-FILE
002500     LABEL RECORDS ARE STANDARD.
002600 01  SALES-RECORD.
002700     05  SALES-STORE              PIC 9(2).
002800     05  SALES-DIVISION           PIC 9(2).
002900     05  SALES-DEPARTMENT         PIC 9(2).
003000     05  SALES-CATEGORY           PIC 9(2).
003100     05  SALES-AMOUNT             PIC S9(6)V99.
003200
003300 WORKING-STORAGE SECTION.
003400
003500 77  THE-STORE                    PIC 99.
003600 77  THE-DIVISION                 PIC 99.
003700 77  THE-DEPARTMENT               PIC 99.
003800 77  THE-CATEGORY                 PIC 99.
003900
004000 77  THE-AMOUNT                   PIC S9(6)V99.
004100
004200 PROCEDURE DIVISION.
004300 PROGRAM-BEGIN.
004400     PERFORM OPENING-PROCEDURE.
004500     PERFORM MAIN-PROCESS.
004600     PERFORM CLOSING-PROCEDURE.
004700
004800 PROGRAM-EXIT.
004900     EXIT PROGRAM.
005000
005100 PROGRAM-DONE.
005200     ACCEPT OMITTED. STOP RUN.
005300
005400 OPENING-PROCEDURE.
005500     OPEN OUTPUT SALES-FILE.
005600
005700 CLOSING-PROCEDURE.
005800     CLOSE SALES-FILE.
005900
006000 MAIN-PROCESS.
006100     MOVE ZEROES TO THE-AMOUNT.
006200     PERFORM GENERATE-STORE-SALES
006300         VARYING THE-STORE FROM 1 BY 1
006400           UNTIL THE-STORE > 6.
006500
006600 GENERATE-STORE-SALES.
006700     PERFORM GENERATE-CATEGORY-SALES
006800         VARYING THE-CATEGORY FROM 1 BY 1
006900           UNTIL THE-CATEGORY > 12.
007000
007100 GENERATE-CATEGORY-SALES.
007200     ADD 237.57 TO THE-AMOUNT.
007300     IF THE-AMOUNT > 800
007400         SUBTRACT 900 FROM THE-AMOUNT.
007500
007600     MOVE THE-AMOUNT TO SALES-AMOUNT.
007700     MOVE THE-STORE TO SALES-STORE.
007800     MOVE THE-CATEGORY TO SALES-CATEGORY.
007900
008000     PERFORM GENERATE-THE-DEPARTMENT.
008100     PERFORM GENERATE-THE-DIVISION.
008200
008300     WRITE SALES-RECORD.
008400
008500 GENERATE-THE-DEPARTMENT.
008600     ADD 1 TO THE-CATEGORY.
008700     DIVIDE THE-CATEGORY BY 2
008800         GIVING THE-DEPARTMENT.
008900     MOVE THE-DEPARTMENT TO SALES-DEPARTMENT.
009000     SUBTRACT 1 FROM THE-CATEGORY.
009100
009200 GENERATE-THE-DIVISION.
009300     ADD 1 TO THE-DEPARTMENT
009400     DIVIDE THE-DEPARTMENT BY 2
009500         GIVING THE-DIVISION.
009600     MOVE THE-DIVISION TO SALES-DIVISION.
009700