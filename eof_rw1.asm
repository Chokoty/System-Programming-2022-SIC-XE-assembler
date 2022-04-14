COPY      START     1000            . 미해결.. ctrl+d 두번누르면 에러남

.prog
FIRST     CLEAR     A
          STL       RETADR          .main 시작지점 저장하기
CLOOP     JSUB      RDREC           .콘솔 입력받기 => ctrl+d 종료(널이 들어가는듯?)
          LDA       LENGTH          .읽은 문자 길이가 0이면 종료
          COMP      ZERO            
          JEQ       ENDFIL
          JSUB      WRREC           .버퍼 콘솔로 출력하기
          J         CLOOP           .EOF까지 입력받기
ENDFIL    LDA       EOF
          STA       BUFFER
          LDA       THREE
          STA       LENGTH
          JSUB      WRREC
          LDL       RETADR
          RSUB                      .무한반복

halt      J         halt            
          END       FIRST           .프로그램 종료

EOF       BYTE      C'EOF'
THREE     WORD      3
ZERO      WORD      0
RETADR    RESW      1
LENGTH    RESW      1
BUFFER    RESB      4096              .입출력버퍼

.
.         SUBRUOTINE  버퍼로 레코드 읽어오기
.
RDREC     LDX       ZERO
          LDA       ZERO
RLOOP     TD        INPUT             .장치 테스트
          JEQ       RLOOP
          RD        INPUT             .문자 하나씩 입력
          COMP      ZERO              .널문자까지 확인 ?
          JEQ       EXIT
          STCH      BUFFER, X
          TIX       MAXLEN            .버퍼 최대 4096     
          JLT       RLOOP
EXIT      STX       LENGTH            .입력받은 길이 저장
          RSUB


INPUT     BYTE      0                  .X'F1'
MAXLEN    WORD      4096

.
.         SUBRUOTINE 버퍼로 레코드 쓰기
.
WRREC     LDX       ZERO
WLOOP     TD        OUTPUT            .장치 테스트
          JEQ       WLOOP 
          LDCH      BUFFER, X
          WD        OUTPUT            .문자 하나씩 출력
          TIX       LENGTH            .LENGTH 만큼 출력 
          JLT       WLOOP
          RSUB

OUTPUT    BYTE      1                .X'05'
          