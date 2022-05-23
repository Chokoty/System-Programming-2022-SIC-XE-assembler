        JSUB    READ        .CALL READ SUBROUTINE

                            .SUBROUTINE 100바이트 RECORD 읽기
READ    LDX     ZERO        .INITIALIZE INDEX REGISTER을 0으로
RLOOP   TD      INDEV       .TEST 입력장치
        JEQ     RLOOP       .LOOP IF DEVICE IS BUSY
        RD      INDEV       .READ A 레지스터로 1바이트
        STCH    RECORD, X   .STORE RECORD로 
        TIX     K100        .ADD 1 TO INDEX REGISTER AND COMPARE NEW VALUE TO 100
        JLT     RLOOP       .LOOP INDEX VALUE가 100보다 작으면
        RSUB

INDEV   BYTE    0           .INPUT DEVICE NUMBER
RECORD  RESB    100         .100BYTE BUFFER FOR INPUT RECORD

ZERO    WORD    0
K100    WORD    100