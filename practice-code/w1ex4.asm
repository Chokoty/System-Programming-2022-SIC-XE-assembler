        LDS     INCR    .S에 load하기, 계속 씀
        LDA     ALPHA
        ADDR    S, A    .A = S + A
        SUB     #1      .# 직접 
        STA     BETA
        LDA     GAMMA
        ADDR     S, A
        SUB     #4      .4를 뺀다
        STA     DELTA

ONE     WORD    1
ALPHA   WORD    7
BETA    RESW    1
GAMMA   WORD    3
DELTA   RESW    1
INCR    WORD    4       .INCR에 4로 초기화하기