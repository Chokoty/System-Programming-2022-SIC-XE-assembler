COPY      START     0               . 

.prog
FIRST     STL       RETADR          .main 시작지점 저장하기
CLOOP     +JSUB     RDREC           .콘솔 입력받기 => ctrl+d 종료(널이 들어가는듯?)
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          COMP      #0              .Direct addressing            
          JEQ       ENDFIL
          JSUB      WRREC           .버퍼 콘솔로 출력하기
          J         CLOOP           .EOF까지 입력받기
ENDFIL    LDA       =C'EOF'         . EOF 문자열 바로 불러오기
          STA       BUFFER
          LDA       #3
          STA       LENGTH
          JSUB      WRREC
          J         @RETADR         .Indirect addressing 주소로 점프
          USE       CDATA           . ????
RETADR    RESW      1
LENGTH    RESW      1
          USE       CBLKS
BUFFER    RESB      4096              .입출력버퍼
BUFEND    EQU       *                 . ?????
MAXLEN    EQU       BUFEND-BUFFER     . ?????
          USE

.
.         SUBRUOTINE  버퍼로 레코드 읽어오기
.
RDREC     CLEAR     X                 .LDX #0 이랑 같은거
          CLEAR     A
          CLEAR     S
          +LDT      #MAXLEN
RLOOP     TD        INPUT             .장치 테스트
          JEQ       RLOOP
          RD        INPUT             .문자 하나씩 입력
          COMPR     A, S              .널문자까지 확인 = COMP #0
          JEQ       EXIT 
          STCH      BUFFER, X
          TIXR      T                 .버퍼 최대 4096     
          JLT       RLOOP
EXIT      STX       LENGTH            .입력받은 길이 저장
          RSUB
          USE       CDATA
INPUT     BYTE      0                  .X'F1'

.
.         SUBRUOTINE 버퍼로 레코드 쓰기
.
          USE
WRREC     CLEAR     X
          LDT       LENGTH
WLOOP     TD        OUTPUT            .장치 테스트
          JEQ       WLOOP 
          LDCH      BUFFER, X
          WD        OUTPUT            .문자 하나씩 출력
          TIXR      T                 .LENGTH 만큼 출력 
          JLT       WLOOP
          RSUB
          USE       CDATA
OUTPUT    BYTE      1                .X'05'            
          END       FIRST           .프로그램 종료
