READ      START     0               

FIRST     STL       RETADR          .main 시작지점 저장하기
          LDB       #LENGTH         
          BASE      LENGTH          .BASE addressing
          JSUB      RDLINE          .콘솔 입력받기 
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          JSUB      WRLINE          . 버퍼 콘솔로 출력하기

          JSUB      RDLINE          .콘솔 입력받기 
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          JSUB      WRLINE          . 버퍼 콘솔로 출력하기    
          .J         @RETADR         . Indirect addressing 주소로 점프
ENDFIL    J         halt
halt      J         halt            
          END       READ             .프로그램 종료

EOF       BYTE      C'EOF'
RETADR    RESW      1
LENGTH    RESW      1
BUFFER    RESB      4096              .입출력버퍼

.
.         SUBRUOTINE  버퍼로 한 줄 읽어오기
.
RDLINE    CLEAR     X                 . LDX #0 이랑 같은거
          CLEAR     A
          LDS       #10
          +LDT       #4096
RLOOP     TD        INPUT             .장치 테스트
          JEQ       RLOOP
          RD        INPUT             .문자 하나씩 입력
          STCH      BUFFER, X
          COMPR     A, S              .엔터까지 확인 = COMP #10
          JEQ       EXIT 
          TIXR      T                 .버퍼 최대 4096     
          JLT       RLOOP
EXIT      LDA       #1
          ADDR      A, X
          STX       LENGTH            .입력받은 길이 저장
          RSUB

INPUT     BYTE      0                  .X'F1'

.
.         SUBRUOTINE 버퍼로 한 줄 쓰기
.
WRLINE    CLEAR     X
          LDT       LENGTH
WLOOP     TD        OUTPUT            .장치 테스트
          JEQ       WLOOP 
          LDCH      BUFFER, X
          WD        OUTPUT            .문자 하나씩 출력
          TIXR      T                 .LENGTH 만큼 출력 
          JLT       WLOOP
          RSUB

OUTPUT    BYTE      1                .X'05'
