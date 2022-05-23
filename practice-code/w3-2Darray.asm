MAIN      START       1000

.data
.MATRIX    RESW        9
ARR       RESW        100
ARRSIZE   WORD        9
WSIZE     WORD        3               .width size?
ENTER     WORD        10              .엔터 #10

ASGAP     

.prog
main      JSUB        RDARR           
          LDA         #0

A         J           A 


.read array 
RDARR     LDS         WSIZE
          LDX         #0
          LDA         ARRSIZE
          MUL         WSIZE
          RMO         A, T
LOOP      LDA         #0
LOOPA     TD          INDEV           .0이면 반복
          JEQ         LOOPA
          RD          INDEV
          COMP        ENTER           .엔터치면 종료
          JEQ         LOOP
          SUB         ASGAP
          STA         ARR, X
          ADDR        S, X
          COMPR       X, T
          JLT         LOOP
          RSUB