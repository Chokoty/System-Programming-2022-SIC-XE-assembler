COPY      START     1000            . 미해결... ctrl+d 두번 누르면 에러남
.
EOF       BYTE      C'EOF'
THREE     WORD      3
ZERO      WORD      0
RETADR    RESW      1
LENGTH    RESW      1
BUFFER    RESB      4096              .입출력버퍼      

.prog
FIRST     STL       RETADR          .main 시작지점 저장하기
CLOOP     JSUB      RDREC           .콘솔 입력받기 => ctrl+d 종료(널이 들어가는듯?)
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          COMP      ZERO            .Direct addressing            
          JEQ       ENDFIL
          JSUB      WRREC           .버퍼 콘솔로 출력하기
          J         CLOOP           .EOF까지 입력받기
ENDFIL    LDA       EOF             . EOF 문자열 바로 불러오기
          STA       BUFFER
          LDA       THREE
          STA       LENGTH
          JSUB      WRREC
          LDL       RETADR
          RSUB
          
.
.         SUBRUOTINE  버퍼로 레코드 읽어오기
.
INPUT     BYTE      0                 .X'F1'
MAXLEN    WORD      4096     

RDREC     LDX       ZERO                 .LDX #0 이랑 같은거
          LDA       ZERO
RLOOP     TD        INPUT             .장치 테스트
          JEQ       RLOOP
          RD        INPUT             .문자 하나씩 입력
          COMPR     A, S              .널문자까지 확인 = COMP #0
          JEQ       EXIT 
          STCH      BUFFER, X         
          TIX       MAXLEN            .TIXR T 또는 TIX MAXLEN    
          JLT       RLOOP
EXIT      STX       LENGTH            .입력받은 길이 저장
          RSUB


.
.         SUBRUOTINE 버퍼로 레코드 쓰기
.
OUTPUT    BYTE      1                .X'05'  

WRREC     LDX       ZERO
WLOOP     TD        OUTPUT            .장치 테스트
          JEQ       WLOOP 
          LDCH      BUFFER, X
          WD        OUTPUT            .문자 하나씩 출력
          TIX       LENGTH            .LENGTH 만큼 출력 
          JLT       WLOOP
          RSUB
          END       FIRST           .프로그램 종료

