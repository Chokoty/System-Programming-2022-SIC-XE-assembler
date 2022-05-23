temp      START   1000

. prog
main      JSUB    READ      . 스택 초기화
          JSUB    WRITE
          
halt      J       halt      . 프로그램 종료
          END     main


.입력 서브루틴

READ      LDX     #0         
          LDS     #200      
RLOOP     TD      INDEV       
          JEQ     RLOOP    
          RD      INDEV       .콘솔읽기
          COMP    #10         .엔터 칠 경우 종료
          JEQ     ENDR  
          STCH    STDIN, X   
          TIXR    S          .버퍼 200 크기제한
          JLT     RLOOP
          RSUB

ENDR      LDA     #0          .끝에 null 넣기  
          STCH    STDIN, X
          RSUB


.출력서브루틴

WRITE     LDX     #0           
          LDS     #200
WLOOP     TD      OUTDEV     
          JEQ     WLOOP    
          LDCH    STDIN, X    . 원래 STDOUT 으로 
          COMP    #0           .null 전까지 출력
          JEQ     ENDW  
          WD      OUTDEV      .콘솔출력
          TIXR    S           .버퍼 200 크기제한
          JLT     WLOOP
          RSUB

ENDW      LDA     #10         .원하면 엔터넣을수도
          LDCH    #10         .엔터 출력 
          WD      OUTDEV 
          RSUB

. data
INDEV     BYTE    0         .INPUT DEVICE NUMBER
OUTDEV    BYTE    1         .OUTPUT DEVICE NUMBER
STDIN     RESB    100         
STDOUT    RESB    100
NUM       WORD    0