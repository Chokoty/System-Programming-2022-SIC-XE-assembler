temp      START   1000
. data
INDEV     BYTE    0         .INPUT DEVICE NUMBER
OUTDEV    BYTE    1         .OUTPUT DEVICE NUMBER
STDIN     RESB    100         
STDOUT    RESB    100
NUM       WORD    0
STR1      BYTE    C'EMPTY'
STR2      BYTE    C'FULL'

. prog
main      JSUB    READ      . 스택 초기화
          .JSUB    STRtoINT
          .JSUB    INTtoSTR
          JSUB    CPSTR
          JSUB    WRITE
          
halt      J       halt      . 프로그램 종료
          END     main

.
READ      LDX     #0         
          LDT     #100
RLOOP     TD      INDEV     
          JEQ     RLOOP    
          RD      INDEV  
          COMP    #10        . 엔터 칠 경우 종료
          JEQ     ENDR  
          STCH    STDIN, X   
          TIXR    T3         . 버퍼 100 크기제한
          JLT     RLOOP
          RSUB

ENDR      LDA     #0         . 끝에 null 넣기
          STCH    STDIN, X
          RSUB

WRITE     LDX     #0         
          LDT     #100
WLOOP     TD      OUTDEV     
          JEQ     WLOOP    
          LDCH    STDIN, X     .STDOUT 
          COMP    #0             . null 전까지 출력
          JEQ     ENDW  
          WD      OUTDEV       
          TIXR    T
          JLT     WLOOP
          RSUB

ENDW      LDA     #10
          RSUB

.
CPSTR     LDX     #0        
          LDT     #100
SLOOP     LDA     #0        . 초기화 필요!
          LDCH    STDIN, X
          COMP    #0        . null 
          JEQ     ENDS 
          SUB     #48       . '1'-'0'
          RMO     A, S      . S레지스터로 옮기기
          LDA     NUM      
          MUL     #10       
          ADDR    S, A      . NUM 자리수 늘리고 S에 있는거 더하기 
          STA     NUM
          TIXR    T
          JLT     SLOOP

ENDS      LDA     #10
          RSUB
