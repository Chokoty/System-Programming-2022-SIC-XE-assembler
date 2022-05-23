        LDX     ZERO
MOVECH  LDCH    STR1, X
        STCH    STR2, X
        TIX     ELEVEN
        JLT     MOVECH
        JEQ     EQUAL

EQUAL   TIX     ELEVEN
        JGT     FIN

FIN     TIX     ELEVEN

STR1    BYTE    C'TEST STRING'
STR2    RESB    11
ZERO    WORD    0
ELEVEN  WORD    11