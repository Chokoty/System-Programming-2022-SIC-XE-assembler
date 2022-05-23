temp      START   1000
. data
INDEV     BYTE    0           .INPUT DEVICE NUMBER
OUTDEV    BYTE    1           .OUTPUT DEVICE NUMBER

STDIN     RESB    100         .입력버퍼
STDOUT    RESB    100         .출력버퍼
NUM       WORD    0           .입출력 변수
NUM2      WORD    1677721     .FFF 4095 까지 가능? 아직 모른다.. FFFFFF 16777215

TEMP      WORD    0

. prog
main      JSUB    READ        .콘솔입력
          .JSUB    STRtoINT
          
          LDA     NUM2
          STA     NUM
          JSUB    INTtoSTR
          JSUB    WRITE
          
halt      J       halt        .프로그램 종료
          END     main

.입력 서브루틴

READ      LDX     #0         
          LDT     #100      
RLOOP     TD      INDEV       
          JEQ     RLOOP    
          RD      INDEV       .콘솔읽기
          COMP    #10         .엔터 칠 경우 종료
          JEQ     ENDR  
          STCH    STDIN, X   
          TIXR    T3          .버퍼 100 크기제한
          JLT     RLOOP
          RSUB

ENDR      LDA     #0          .끝에 null 넣기  
          STCH    STDIN, X
          RSUB

.출력서브루틴

WRITE     LDX     #0           
          LDT     #100
WLOOP     TD      OUTDEV     
          JEQ     WLOOP    
          LDCH    STDOUT, X     
          COMP    #0           .null 전까지 출력
          JEQ     ENDW  
          WD      OUTDEV      .콘솔출력
          TIXR    T           .버퍼 100 크기제한
          JLT     WLOOP
          RSUB

ENDW      LDA     #10         .원하면 엔터넣을수도
          LDCH    #10         .엔터 출력 
          WD      OUTDEV 
          RSUB


.문자열->정수

STRtoINT  LDX     #0          .입력버퍼에서 NUM으로 가져오기
          LDT     #100
          LDA     #0
          STA     NUM         .num도 초기화!
SLOOP     LDA     #0          .초기화 필요!
          LDCH    STDIN, X
          COMP    #0          .null 체크
          JEQ     ENDS 
          SUB     #48         .'1'-'0' 숫자로 변환
          RMO     A, S        .S 레지스터로 옮기기
          LDA     NUM         .기존의 값을 불러와서 자릿수 증가
          MUL     #10         
          ADDR    S, A        .NUM에 값 더해주기
          STA     NUM
          TIXR    T           .버퍼 100 크기제한
          JLT     SLOOP

ENDS      LDA     #10
          RSUB


.정수->문자열

INTtoSTR  LDX     #0        . NUM을 출력버퍼로 내보내기

          LDA     NUM
ILOOP1    COMP    #10       . 길이 구하기
          JLT     IEND1
          DIV     #10
          RMO     A, S
          LDA     TEMP
          ADD     #1
          STA     TEMP
          RMO     S, A
          J       ILOOP1
IEND1     LDA     #0

          LDX     TEMP
ILOOP2    LDA     NUM       .출력버퍼에 문자열로 넣기
          COMP    #10 
          JLT     IEND2
          RMO     A, S 
          DIV     #10
          STA     NUM       .123 -> 12 3 분리
          MUL     #10
          SUBR    A, S      .S에 3이 있음
          RMO     S, A 
          ADD     #48       . +'0' 문자로 변환
          STCH    STDOUT, X
          LDA     #1
          SUBR    A, X
          J       ILOOP2

IEND2     ADD     #48
          STCH    STDOUT, X
          RSUB
