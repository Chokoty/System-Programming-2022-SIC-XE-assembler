INLOOP  TD      INDEV     .TEST 입력장치
        JEQ     INLOOP    .LOOP 장치 준비될 때 까지
        RD      INDEV     .READ 입력장치에서 A 레지스터로 1 바이트  
        STCH    DATA      .STORE 읽은 거 바이트

OUTLP   TD      OUTDEV    .TEST 출력장치
        JEQ     OUTLP     .LOOP 장치 준비될 때 까지
        LDCH    DATA      .LOAD A 레지스터로 
        WD      OUTDEV    .WRITE 출력장치로 1 바이트 

INDEV   BYTE    0         .INPUT DEVICE NUMBER
OUTDEV  BYTE    1         .OUTPUT DEVICE NUMBER
DATA    RESB    1         .ONE-BYTE VARIABLE