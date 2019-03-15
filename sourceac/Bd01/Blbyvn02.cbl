000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. BLBYVN02.
000300*---------------------------------
000400* Bills Report by vendor
000500*---------------------------------
000600 ENVIRONMENT DIVISION.
000700 INPUT-OUTPUT SECTION.
000800 FILE-CONTROL.
000900
001000     COPY "SLVOUCH.CBL".
001100
001200     COPY "SLVND02.CBL".
001300
001400     COPY "SLSTATE.CBL".
001500
001600     SELECT WORK-FILE
001700         ASSIGN TO "WORK"
001800         ORGANIZATION IS SEQUENTIAL.
001900
002000     SELECT SORT-FILE
002100         ASSIGN TO "SORT".
002200
002300     SELECT PRINTER-FILE
002400         ASSIGN TO PRINTER
002500         ORGANIZATION IS LINE SEQUENTIAL.
002600
002700 DATA DIVISION.
002800 FILE SECTION.
002900
003000     COPY "FDVOUCH.CBL".
003100
003200     COPY "FDVND04.CBL".
003300
003400     COPY "FDSTATE.CBL".
003500
003600 FD  WORK-FILE
003700     LABEL RECORDS ARE STANDARD.
003800 01  WORK-RECORD.
003900     05  WORK-NUMBER           PIC 9(5).
004000     05  WORK-VENDOR           PIC 9(5).
004100     05  WORK-INVOICE          PIC X(15).
004200     05  WORK-FOR              PIC X(30).
004300     05  WORK-AMOUNT           PIC S9(6)V99.
004400     05  WORK-DATE             PIC 9(8).
004500     05  WORK-DUE              PIC 9(8).
004600     05  WORK-DEDUCTIBLE       PIC X.
004700     05  WORK-SELECTED         PIC X.
004800     05  WORK-PAID-AMOUNT      PIC S9(6)V99.
004900     05  WORK-PAID-DATE        PIC 9(8).
005000     05  WORK-CHECK-NO         PIC 9(6).
005100
005200 SD  SORT-FILE.
005300
005400 01  SORT-RECORD.
005500     05  SORT-NUMBER           PIC 9(5).
005600     05  SORT-VENDOR           PIC 9(5).
005700     05  SORT-INVOICE          PIC X(15).
005800     05  SORT-FOR              PIC X(30).
005900     05  SORT-AMOUNT           PIC S9(6)V99.
006000     05  SORT-DATE             PIC 9(8).
006100     05  SORT-DUE              PIC 9(8).
006200     05  SORT-DEDUCTIBLE       PIC X.
006300     05  SORT-SELECTED         PIC X.
006400     05  SORT-PAID-AMOUNT      PIC S9(6)V99.
006500     05  SORT-PAID-DATE        PIC 9(8).
006600     05  SORT-CHECK-NO         PIC 9(6).
006700
006800 FD  PRINTER-FILE
006900     LABEL RECORDS ARE OMITTED.
007000 01  PRINTER-RECORD             PIC X(80).
007100
007200 WORKING-STORAGE SECTION.
007300
007400 77  OK-TO-PROCESS         PIC X.
007500
007600     COPY "WSCASE01.CBL".
007700
007800 01  DETAIL-LINE.
007900     05  PRINT-NAME        PIC X(30).
008000     05  FILLER            PIC X(1) VALUE SPACE.
008100     05  PRINT-NUMBER      PIC ZZZZ9.
008200     05  FILLER            PIC X(3) VALUE SPACE.
008300     05  PRINT-DUE-DATE    PIC Z9/99/9999.
008400     05  FILLER            PIC X(1) VALUE SPACE.
008500     05  PRINT-AMOUNT      PIC ZZZ,ZZ9.99.
008600     05  FILLER            PIC X(1) VALUE SPACE.
008700     05  PRINT-INVOICE     PIC X(15).
008800
008900 01  VENDOR-TOTAL-LITERAL.
009000     05  FILLER            PIC X(18) VALUE SPACE.
009100     05  FILLER            PIC X(12) VALUE "VENDOR TOTAL".
009200
009300 01  GRAND-TOTAL-LITERAL.
009400     05  FILLER            PIC X(25) VALUE SPACE.
009500     05  FILLER            PIC X(5) VALUE "TOTAL".
009600
009700 01  COLUMN-LINE.
009800     05  FILLER         PIC X(6) VALUE "VENDOR".
009900     05  FILLER         PIC X(23) VALUE SPACE.
010000     05  FILLER         PIC X(7)  VALUE "VOUCHER".
010100     05  FILLER         PIC X(5)  VALUE SPACE.
010200     05  FILLER         PIC X(8)  VALUE "DUE DATE".
010300     05  FILLER         PIC X(1)  VALUE SPACE.
010400     05  FILLER         PIC X(10) VALUE "AMOUNT DUE".
010500     05  FILLER         PIC X(1)  VALUE SPACE.
010600     05  FILLER         PIC X(7)  VALUE "INVOICE".
010700
010800 01  TITLE-LINE.
010900     05  FILLER              PIC X(25) VALUE SPACE.
011000     05  FILLER              PIC X(22)
011100         VALUE "BILLS REPORT BY VENDOR".
011200     05  FILLER              PIC X(11) VALUE SPACE.
011300     05  FILLER              PIC X(5) VALUE "PAGE:".
011400     05  FILLER              PIC X(1) VALUE SPACE.
011500     05  PRINT-PAGE-NUMBER   PIC ZZZ9.
011600
011700 77  WORK-FILE-AT-END     PIC X.
011800 77  VENDOR-RECORD-FOUND     PIC X.
011900
012000 77  LINE-COUNT              PIC 999 VALUE ZERO.
012100 77  PAGE-NUMBER             PIC 9999 VALUE ZERO.
012200 77  MAXIMUM-LINES           PIC 999 VALUE 55.
012300
012400 77  RECORD-COUNT            PIC 9999 VALUE ZEROES.
012500
012600* Control break current value for vendor
012700 77  CURRENT-VENDOR          PIC 9(5).
012800
012900* Control break accumulators
013000* GRAND TOTAL is the level 1 accumulator for the whole file
013100* VENDOR TOTAL is the level 2 accumulator
013200 77  GRAND-TOTAL            PIC S9(6)V99.
013300 77  VENDOR-TOTAL           PIC S9(6)V99.
013400
013500     COPY "WSDATE01.CBL".
013600
013700 PROCEDURE DIVISION.
013800 PROGRAM-BEGIN.
013900
014000     PERFORM OPENING-PROCEDURE.
014100     PERFORM MAIN-PROCESS.
014200     PERFORM CLOSING-PROCEDURE.
014300
014400 PROGRAM-EXIT.
014500     EXIT PROGRAM.
014600
014700 PROGRAM-DONE.
014800     ACCEPT OMITTED. STOP RUN.
014900
015000 OPENING-PROCEDURE.
015100     OPEN I-O VENDOR-FILE.
015200
015300     OPEN OUTPUT PRINTER-FILE.
015400
015500 MAIN-PROCESS.
015600     PERFORM GET-OK-TO-PROCESS.
015700     PERFORM PROCESS-THE-FILE
015800         UNTIL OK-TO-PROCESS = "N".
015900
016000 CLOSING-PROCEDURE.
016100     CLOSE VENDOR-FILE.
016200     CLOSE PRINTER-FILE.
016300
016400 GET-OK-TO-PROCESS.
016500     PERFORM ACCEPT-OK-TO-PROCESS.
016600     PERFORM RE-ACCEPT-OK-TO-PROCESS
016700         UNTIL OK-TO-PROCESS = "Y" OR "N".
016800
016900 ACCEPT-OK-TO-PROCESS.
017000     DISPLAY "PRINT BILLS BY VENDOR (Y/N)?".
017100     ACCEPT OK-TO-PROCESS.
017200     INSPECT OK-TO-PROCESS
017300       CONVERTING LOWER-ALPHA
017400       TO         UPPER-ALPHA.
017500
017600 RE-ACCEPT-OK-TO-PROCESS.
017700     DISPLAY "YOU MUST ENTER YES OR NO".
017800     PERFORM ACCEPT-OK-TO-PROCESS.
017900
018000 PROCESS-THE-FILE.
018100     PERFORM START-THE-FILE.
018200     PERFORM PRINT-ONE-REPORT.
018300     PERFORM END-THE-FILE.
018400
018500*    PERFORM GET-OK-TO-PROCESS.
018600     MOVE "N" TO OK-TO-PROCESS.
018700
018800 START-THE-FILE.
018900     PERFORM SORT-DATA-FILE.
019000     OPEN INPUT WORK-FILE.
019100
019200 END-THE-FILE.
019300     CLOSE WORK-FILE.
019400
019500 SORT-DATA-FILE.
019600     SORT SORT-FILE
019700         ON ASCENDING KEY SORT-VENDOR
019800          USING VOUCHER-FILE
019900          GIVING WORK-FILE.
020000
020100* LEVEL 1 CONTROL BREAK
020200 PRINT-ONE-REPORT.
020300     PERFORM START-ONE-REPORT.
020400     PERFORM PROCESS-ALL-VENDORS
020500         UNTIL WORK-FILE-AT-END = "Y".
020600     PERFORM END-ONE-REPORT.
020700
020800 START-ONE-REPORT.
020900     PERFORM READ-FIRST-VALID-WORK.
021000     MOVE ZEROES TO GRAND-TOTAL.
021100
021200     PERFORM START-NEW-REPORT.
021300
021400 START-NEW-REPORT.
021500     MOVE SPACE TO DETAIL-LINE.
021600     MOVE ZEROES TO LINE-COUNT PAGE-NUMBER.
021700     PERFORM START-NEW-PAGE.
021800
021900 END-ONE-REPORT.
022000     IF RECORD-COUNT = ZEROES
022100         MOVE "NO RECORDS FOUND" TO PRINTER-RECORD
022200         PERFORM WRITE-TO-PRINTER
022300     ELSE
022400         PERFORM PRINT-GRAND-TOTAL.
022500
022600     PERFORM END-LAST-PAGE.
022700
022800 PRINT-GRAND-TOTAL.
022900     MOVE GRAND-TOTAL TO PRINT-AMOUNT.
023000     MOVE GRAND-TOTAL-LITERAL TO PRINT-NAME.
023100     MOVE DETAIL-LINE TO PRINTER-RECORD.
023200     PERFORM WRITE-TO-PRINTER.
023300     PERFORM LINE-FEED 2 TIMES.
023400     MOVE SPACE TO DETAIL-LINE.
023500
023600* LEVEL 2 CONTROL BREAK
023700 PROCESS-ALL-VENDORS.
023800     PERFORM START-ONE-VENDOR.
023900
024000     PERFORM PROCESS-ALL-VOUCHERS
024100         UNTIL WORK-FILE-AT-END = "Y"
024200            OR WORK-VENDOR NOT = CURRENT-VENDOR.
024300
024400     PERFORM END-ONE-VENDOR.
024500
024600 START-ONE-VENDOR.
024700     MOVE WORK-VENDOR TO CURRENT-VENDOR.
024800     MOVE ZEROES TO VENDOR-TOTAL.
024900
025000     PERFORM LOAD-VENDOR-NAME.
025100
025200 LOAD-VENDOR-NAME.
025300     MOVE WORK-VENDOR TO VENDOR-NUMBER.
025400     PERFORM READ-VENDOR-RECORD.
025500     IF VENDOR-RECORD-FOUND = "Y"
025600         MOVE VENDOR-NAME TO PRINT-NAME
025700     ELSE
025800         MOVE "*VENDOR NOT ON FILE*" TO PRINT-NAME.
025900
026000 END-ONE-VENDOR.
026100     PERFORM PRINT-VENDOR-TOTAL.
026200     ADD VENDOR-TOTAL TO GRAND-TOTAL.
026300
026400 PRINT-VENDOR-TOTAL.
026500     MOVE VENDOR-TOTAL TO PRINT-AMOUNT.
026600     MOVE VENDOR-TOTAL-LITERAL TO PRINT-NAME.
026700     MOVE DETAIL-LINE TO PRINTER-RECORD.
026800     PERFORM WRITE-TO-PRINTER.
026900     PERFORM LINE-FEED.
027000     MOVE SPACE TO DETAIL-LINE.
027100
027200* PROCESS ONE RECORD LEVEL
027300 PROCESS-ALL-VOUCHERS.
027400     PERFORM PROCESS-THIS-VOUCHER.
027500     ADD WORK-AMOUNT TO VENDOR-TOTAL.
027600     ADD 1 TO RECORD-COUNT.
027700     PERFORM READ-NEXT-VALID-WORK.
027800
027900 PROCESS-THIS-VOUCHER.
028000     IF LINE-COUNT > MAXIMUM-LINES
028100         PERFORM START-NEXT-PAGE.
028200     PERFORM PRINT-THE-RECORD.
028300
028400 PRINT-THE-RECORD.
028500     MOVE WORK-NUMBER TO PRINT-NUMBER.
028600
028700     MOVE WORK-DUE TO DATE-CCYYMMDD.
028800     PERFORM CONVERT-TO-MMDDCCYY.
028900     MOVE DATE-MMDDCCYY TO PRINT-DUE-DATE.
029000
029100     MOVE WORK-AMOUNT TO PRINT-AMOUNT.
029200     MOVE WORK-INVOICE TO PRINT-INVOICE.
029300
029400     MOVE DETAIL-LINE TO PRINTER-RECORD.
029500     PERFORM WRITE-TO-PRINTER.
029600     MOVE SPACE TO DETAIL-LINE.
029700
029800* PRINTING ROUTINES
029900 WRITE-TO-PRINTER.
030000     WRITE PRINTER-RECORD BEFORE ADVANCING 1.
030100     ADD 1 TO LINE-COUNT.
030200
030300 LINE-FEED.
030400     MOVE SPACE TO PRINTER-RECORD.
030500     PERFORM WRITE-TO-PRINTER.
030600
030700 START-NEXT-PAGE.
030800     PERFORM END-LAST-PAGE.
030900     PERFORM START-NEW-PAGE.
031000
031100 START-NEW-PAGE.
031200     ADD 1 TO PAGE-NUMBER.
031300     MOVE PAGE-NUMBER TO PRINT-PAGE-NUMBER.
031400     MOVE TITLE-LINE TO PRINTER-RECORD.
031500     PERFORM WRITE-TO-PRINTER.
031600     PERFORM LINE-FEED.
031700     MOVE COLUMN-LINE TO PRINTER-RECORD.
031800     PERFORM WRITE-TO-PRINTER.
031900     PERFORM LINE-FEED.
032000
032100 END-LAST-PAGE.
032200     PERFORM FORM-FEED.
032300     MOVE ZERO TO LINE-COUNT.
032400
032500 FORM-FEED.
032600     MOVE SPACE TO PRINTER-RECORD.
032700     WRITE PRINTER-RECORD BEFORE ADVANCING PAGE.
032800
032900*---------------------------------
033000* Read first, read next routines
033100*---------------------------------
033200 READ-FIRST-VALID-WORK.
033300     PERFORM READ-NEXT-VALID-WORK.
033400
033500 READ-NEXT-VALID-WORK.
033600     PERFORM READ-NEXT-WORK-RECORD.
033700     PERFORM READ-NEXT-WORK-RECORD
033800         UNTIL WORK-FILE-AT-END = "Y"
033900            OR WORK-PAID-DATE = ZEROES.
034000
034100 READ-NEXT-WORK-RECORD.
034200     MOVE "N" TO WORK-FILE-AT-END.
034300     READ WORK-FILE NEXT RECORD
034400         AT END MOVE "Y" TO WORK-FILE-AT-END.
034500
034600*---------------------------------
034700* Other File IO routines
034800*---------------------------------
034900 READ-VENDOR-RECORD.
035000     MOVE "Y" TO VENDOR-RECORD-FOUND.
035100     READ VENDOR-FILE RECORD
035200         INVALID KEY
035300         MOVE "N" TO VENDOR-RECORD-FOUND.
035400
035500*---------------------------------
035600* Utility Routines
035700*---------------------------------
035800     COPY "PLDATE01.CBL".
035900