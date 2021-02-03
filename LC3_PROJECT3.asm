;The program input n strings of characters with the length unlimited from keyboard, 
;press ENTER to input next string, press ENTER 2 times to stop inputting, redundant character, for example "," " " will be omited
;you can choose to sort ASCENDING or DESCENDING
.ORIG  x3000
       AND R4, R4, #0      ; clear R4, R4 will be the number of strings inputted
       AND R5, R5, #0      ; clear R5
       LD R5, ARRAY        ; R5 <-- x5000 (x5000 is the first address of ARRAY, ARRAY includes addresses of strings' first character)
       LEA R0, IN_String
       PUTS
       AND R0, R0, #0      ; Print new line
       ADD R0, R0, #10
       OUT
       JSR INPUT           ; Input subroutine
       ADD R4, R4, #-1  
       ST R4, LENGTH       ; save R4 to LENGTH
       LEA R0, Selection   ; print to notify selection
       PUTS
AGAIN  AND R0, R0, #0      ; print new line
       ADD R0, R0, #10
       OUT 
       LEA R0, Selection1
       PUTS
       GETC                ; input selection
       OUT
       LD R1, ASCII        ; R1 <-- -x30
       ADD R5, R0, R1      ; convert string to number
       ADD R5, R5, #-1     ; check whether it is 1 or not
       BRz LOOP1 
       ADD R5, R0, R1
       ADD R5, R5, #-2     ; check whether it is 2 or not
       BRz LOOP7           
       BR AGAIN            ; if it is not 1 or 2, input again
;---ASCENDING ORDER--------;     
LOOP1  LD R5, ARRAY
       ADD R1, R4, #0
LOOP2  LDR R0,R5,#0        ; R0 stores address of first character 
       LDR R2,R0,#0        ; R2 stores the first character
       LDR R6,R5,#1        ; R6 stores address of first character of next string
       LDR R3,R6,#0        ; R3 stores the first character of next string
LOOP3  JSR COMPARE
       ADD R2,R2,#0
       BRp LABEL           ; If following character is bigger than previous one, do nothing
       BRz EQUAL           ; If following character is equal the previous one, jump to EQUAL
       JSR CONVERT 
LABEL  ADD R5,R5,#1        ; points to next address in ARRAY
       ADD R1,R1,#-1       ; R1 length of string - 1
       BRP LOOP2
       ADD R4,R4,#-1       ; R4: number of loop
       BRp LOOP1
       JSR PRINT
       BR STOP_END
;--------------------------;
;---DESCENDING ORDER-------; 
       LD R4, LENGTH       
LOOP7  LD R5, ARRAY        ; R5 <-- x5000 (x5000 is the first address of ARRAY, ARRAY includes addresses of strings' first character)
       ADD R1, R4, #0
LOOP8  LDR R0,R5,#0        ; R0 stores address of first character 
       LDR R2,R0,#0        ; R2 stores the first character
       LDR R6,R5,#1        ; R6 stores address of first character of next string
       LDR R3,R6,#0        ; R3 stores the first character of next string
LOOP9  JSR COMPARE1
       ADD R2,R2,#0
       BRn LABEL1          ; If following character is bigger than previous one, do nothing
       BRz EQUAL1          ; If following character is equal the previous one, jump to EQUAL
       JSR CONVERT1 
LABEL1 ADD R5,R5,#1        ; points to next address in ARRAY
       ADD R1,R1,#-1       ; R1 length of string - 1
       BRP LOOP8
       ADD R4,R4,#-1       ; R4: number of loop
       BRp LOOP7
       JSR PRINT
;--------------------------;
STOP_END  HALT


;----Input subroutine------;
INPUT     ST R7,SAVE_R7    ; save R7
          LEA R2, DATA     ; R2 stores the address of DATA
          AND R4, R4, #0   ; clear R4
          STR R2, R5, #0   ; store address of first character to ARRAY
          ADD R5, R5, #1   ; points to next address in AARAY to store
LOOP      GETC             ; input from keyboard
LOOP0     ADD R1,R0,x-10
          ADD R1,R1,X-10   ; If there is blank, don't store in memory
          BRZ LOOP
          ADD R1,R1,x-0C
          BRZ LOOP         ; If there is a comma, don't store in memory
          STR R0, R2, #0
          ADD R1, R0, x-0A ; When press Enter, end string
          BRZ END_str
          OUT
          ADD R2, R2, #1   ; point to next character
          BR LOOP          ; return LOOP
END_str   ADD R4, R4, #1   ; R4: number of strings inputted
          STR R0, R2, #0   ; store characters to DATA
          ADD R2, R2, #1   ; points to next address in DATA
          OUT              ; print character just inputted
          GETC             ; input from keyboard
          ADD R1, R0, x-0A ; When press Enter 2 times, stop inputting
          BRZ STOP
          STR R2, R5, #0   ; store the address of first character to ARRAY
          ADD R5, R5, #1   ; points to next address in AARAY to store
          BR LOOP0
STOP      LD R7,SAVE_R7    ; load R7 to return
          RET
;---------------------;
;COMPARE subroutine: Doing subtraction to check which one is bigger
COMPARE NOT R2,R2         
        ADD R2,R2,#1       ; negative R2
        ADD R2,R2,R3       ; do substraction to compare
        RET
;----------------------;
;CONVERT subroutine: Changing the order of addresses' first character which is in ARRAY
CONVERT LDR R2,R5,#0       ; store addresses' first character to R2
        LDR R3,R5,#1       ; store next addresses' first character to R3
        STR R2,R5,#1       ; do conversion 
        STR R3,R5,#0      
        RET
;--------------------------;
EQUAL ADD R0, R0, #1       ; points to the address of next character of a string
      ADD R6, R6, #1       ; points to the address of next character of next string
      LDR R2, R0, #0       ; R3 stores the next character of string
      LDR R3, R6, #0       ; R3 stores the next character of next string
      BR LOOP3
;;;;;;;;;;;;;;;;;;;;;;;
;COMPARE1 subroutine: Doing subtraction to check which one is bigger
COMPARE1 NOT R2,R2         
         ADD R2,R2,#1       ; negative R2
         ADD R2,R2,R3       ; do substraction to compare
         RET
;----------------------;
;CONVERT1: Changing the order of addresses' first character which is in ARRAY
CONVERT1 LDR R2,R5,#0       ; store addresses' first character to R2
         LDR R3,R5,#1       ; store next addresses' first character to R3
         STR R2,R5,#1       ; do conversion 
         STR R3,R5,#0      
         RET
;---------------------------;
EQUAL1 ADD R0, R0, #1       ; points to the address of next character of a string
       ADD R6, R6, #1       ; points to the address of next character of next string
       LDR R2, R0, #0       ; R3 stores the next character of string
       LDR R3, R6, #0       ; R3 stores the next character of next string
       BR LOOP9
;--Print subroutine---------;
PRINT ST R7, SAVE_R7        ; store R7
      LD R5, ARRAY          ; R5 <-- x5000 (x5000 is the first address of ARRAY, ARRAY includes addresses of strings' first character)
      AND R0, R0, #0        ; print new line
      ADD R0, R0, #10
      OUT   
LOOP4 LDR R2,R5,#0          ; R2 stores address of first character 
      BRz STOP_Pr           ; equals 0 means no string to print 
LOOP5 LDR R0, R2, #0        ; R0 stores first character 
      ADD R1, R0, #-10      ; check whether new string or not by compare to know whether ENTER or not
      BRz Pr_New_str
      OUT              
      ADD R2, R2, #1        ; points to next character in string
      BR LOOP5
      
Pr_New_str OUT
           ADD R5, R5, #1             ; points to next address in ARRAY
           BR LOOP4
           STOP_Pr LD R7, SAVE_R7     ; load R7 to return
           RET
;--------------------------;
SAVE_R7 .BLKW 1
SAVE_R6 .BLKW 1
LENGTH  .BLKW 1
ARRAY   .FILL x5000
ASCII .FILL x-30
IN_String  .STRINGZ "Please input strings"
Selection  .STRINGZ "1.ASCENDING   2.DESCENDING"
Selection1 .STRINGZ "Please press 1 or 2 to choose: "
DATA       .FILL x0000
.END     