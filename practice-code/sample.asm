project     START     0

.           #### PROG ####

.           main 함수 작성하는 부분
main        STL       RETADR          . main 으로 시작하면 됨
...             

halt        J         halt            . 프로그램 종료
            END       main


. 메인에서 쓰는 변수들 작성하는 부분
RETADR      RESW      1
LENGTH      RESW      1
BUFFER      RESB      4096              

N           RESW      1           . 도시
K           RESW      1           . 길이
SC          RESW      1           . 출발도시
EC          RESW      1           . 도착도시


.           #### SUBRUOTINE ####

.
.           SUBRUOTINE : ㅇㅇ 하는 서브루틴
.
RDLINE      CLEAR     X                 . LDX #0 이랑 같은거
            CLEAR     A
            LDS       #10
            +LDT      #4096
RLOOP       TD        INDEV             .장치 테스트
            JEQ       RLOOP
            RD        INDEV             .문자 하나씩 입력
            STCH      BUFFER, X
            COMPR     A, S              .엔터까지 확인 = COMP #10
            JEQ       EXIT 
            TIXR      T                 .버퍼 최대 4096     
            JLT       RLOOP
EXIT        LDA       #1
            ADDR      A, X
            STX       LENGTH            .입력받은 길이 저장
            RSUB

INDEV       BYTE      0                  .X'F1'

... 서브루틴 작성하기


            END       main              . 전체 코드 종료 해주는 부분