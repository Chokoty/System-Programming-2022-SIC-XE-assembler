        LDA     ALPHA
        ADD     INCR
        SUB     ONE
        STA     BETA
        LDA     GAMMA
        ADD     INCR
        SUB     ONE
        STA     DELTA

ONE     WORD    1
ALPHA   WORD    7
BETA    RESW    1
GAMMA   WORD    3
DELTA   RESW    1
INCR    RESW    1