COPY      START     1000
FIRST     STL       RETADR          . 시작지점 저장하기
CLOOP     JSUB      RDREC           . 콘솔 입력받기
          LDA       LENGTH          
          COMP      ZERO            . 입력받은게 없으면 종료
          JEQ       ENDFIL          
          JSUB      WRREC           . 버퍼 콘솔로 출력하기
          J         CLOOP
ENDFIL    LDA       EOF
          STA       BUFFER
          LDA       THREE
          STA       LENGTH
          JSUB      WRREC
          LDL       RETADR
          RSUB
halt      J         halt 

EOF       BYTE      C'EOF'
THREE     WORD      3
ZERO      WORD      0
RETADR    RESW      1
LENGTH    RESW      1
BUFFER    RESB      4096

.
RDREC       CSECT
.
.           입력 서브루틴
.
            EXTREF    BUFFER, LENGTH
            CLEAR     X        
            CLEAR     A 
            CLEAR     S  
            LDT       #100                .   MAXLEN으로 교체 
RLOOP       TD        INPUT     
            JEQ       RLOOP
            RD        INPUT               
            COMPR     A, S                .엔터까지 입력함 0 = 0 종료
            JEQ       EXIT  
            STCH      BUFFER, X   
            TIXR      T                   .버퍼 100 크기제한
            JLT       RLOOP
EXIT        STX       LENGTH   
            RSUB

INPUT       BYTE      X'F1'               . INPUT   BYTE  X'F1'  ?? 이름 약속?
MAXLEN      WORD      100                 . ?



WRREC       CSECT         
.
.           출력서브루틴
.
            EXTREF    LENGTH, BUFFER
            CLEAR     X
            LDT       LENGTH              
WLOOP       TD        OUTPUT     
            JEQ       WLOOP    
            LDCH      BUFFER, X     
            WD        OUTPUT              .콘솔출력
            TIXR      T                   .버퍼 100 크기제한
            JLT       WLOOP
            RSUB

OUTPUT      BYTE      X'05'               . OUTPUT  BYTE  X'05'        