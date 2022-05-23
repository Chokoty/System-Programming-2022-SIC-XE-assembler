COPY      START     0               . 시작위치는 Loader가 알고 있다.

.prog
FIRST     STL       RETADR          .main 시작지점 저장하기
          LDB       #LENGTH         . XE버전 B 레지스터
          BASE      LENGTH          . BASE addressing
CLOOP     +JSUB      RDREC          .콘솔 입력받기 => ctrl+d 종료(널이 들어가는듯?)
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          COMP      #0              . Direct addressing            
          JEQ       ENDFIL
          +JSUB      WRREC          . 버퍼 콘솔로 출력하기
          J         CLOOP           .EOF까지 입력받기
ENDFIL    LDA       EOF
          STA       BUFFER
          LDA       #3
          STA       LENGTH
          +JSUB      WRREC
          J         @RETADR         . Indirect addressing 주소로 점프

halt      J         halt            
          END       FIRST           .프로그램 종료

EOF       BYTE      C'EOF'
RETADR    RESW      1
LENGTH    RESW      1
BUFFER    RESB      4096              .입출력버퍼

.
.         SUBRUOTINE  버퍼로 레코드 읽어오기
.
RDREC     CLEAR     X                 . LDX #0 이랑 같은거
          CLEAR     A
          CLEAR     S
          +LDT       #4096
RLOOP     TD        INPUT             .장치 테스트
          JEQ       RLOOP
          RD        INPUT             .문자 하나씩 입력
          COMPR     A, S              . 널문자까지 확인 = COMP #0
          JEQ       EXIT 
          STCH      BUFFER, X
          TIXR      T                .버퍼 최대 4096     
          JLT       RLOOP
EXIT      STX       LENGTH            .입력받은 길이 저장
          RSUB


INPUT     BYTE      0                  .X'F1'

.
.         SUBRUOTINE 버퍼로 레코드 쓰기
.
WRREC     CLEAR     X
          LDT       LENGTH
WLOOP     TD        OUTPUT            .장치 테스트
          JEQ       WLOOP 
          LDCH      BUFFER, X
          WD        OUTPUT            .문자 하나씩 출력
          TIXR      T                 .LENGTH 만큼 출력 
          JLT       WLOOP
          RSUB

OUTPUT    BYTE      1                .X'05'
