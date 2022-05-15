# System-Programming-2022-SIC/XE-assembler
Ajou Univ. System Programming (SCE214) - SIC/XE Machine Practice

# 시스템 프로그래밍 2022
- Notion 정리글 >
# 기본적인 뼈대 코드들을 올림
- 교재 코드
- 기본 구조
- 기본콘솔 입출력
- 스택
- 2차원 배열
- ...

# 과제 코드는 올리지 않음

# 실습

## 이용 툴: SicTools

- 설치, 사용설명: [http://jurem.github.io/SicTools/](http://jurem.github.io/SicTools/)
- 환경: vmware 우분투 20.04 / WSL2 (win11이라면 wlsg로 사용 가능!)
- 리눅스 기준 세팅:
    
    - git 설치하기 `**sudo apt-get install git**`
    - vim 설치하기 `**sudo apt-get install vim**`
    - java 설치하기 `**sudo apt-get install openjdk-8-jdk**`
    
- sictool시뮬 실행: `**java -jar out/make/sictools.jar**`

## assembler directive

- START : 프로그램 이름, 시작주소
- END : 원시프로그램(source program)의 끝, 선택적으로 최초 실행할 명령어
- BYTE : 상수생성, 문자 or 16진수
- WORD : 1워드 정수 상수 생성 **⇒ 값 할당 되어있다**
- RESB : 지시된 바이트 수 만큼 예약 **⇒ 값이 비어있다 0**
- RESW : 지시된 워드 수 만큼 예약

## 기본적인 asm 작성법(작성중)
- 
- 
## Data Movement

- SIC는 `ALPHA RESW 1` -> 1byte 할당해서 ALPHA 변수 생성하는 식으로 상수 저장
    
- SIC/XE는 #(immediate mode)를 붙이면 바로 값을 상수로 사용가능. 따라서 굳이 값을 변수에 저장할 필요 X (메모리를 거치지 않으므로 속도 증가)

- ex1.asm
    
    ```
              LDA 	  FIVE  	.LOAD CONSTANT 5 INTO REGISTER A
              STA 	  ALPHA 	.STORE IN ALPHA
              LDCH  	CHARZ 	.LOAD CHARACTER 'Z' INTO REGISTER A
              STCH  	C1  	  .STORE IN CHARACTER VARIABLE C1
      
      ALPHA 	RESW  	1 	    .ONE-WORD VARIABLE
      FIVE 	  WORD 	  5 	    .ONE-WORD CONSTANT
      CHARZ 	BYTE  	C'Z'  	.ONE-BYTE CONSTANT
      C1  	  RESB  	1 	    .ONE-BYTE VARIABLE
    ```
    
    - **A : load 5 ⇒ store 5 ⇒ load ‘Z’ ⇒ store ‘Z’**
        
        ALPHA : 1  → 5 store
        
        FIVE : 5  → 5 load
        
        CHARZ : ‘Z’ → ‘Z’ load
        
        C1 : 1 → ‘Z’ store
        
- ex2.asm
    ```
              LDA 	  #5  	  .LOAD IMMEDIATE VALUE 5 INTO REGISTER A
              STA 	  ALPHA 	.STORE IN ALPHA
              LDCH  	#90 	  .LOAD ASCII CODE FOR 'Z' INTO REGISTER A
              STCH  	C1      .STORE IN CHARACTER VARIABLE C1

    ALPHA 	  RESW  	1 	    .ONE-WORD VARIABLE
    C1  	    RESB  	1 	    .ONE-BYTE VARIABLE
    ```
    - 5, ‘Z’를 변수에 넣지 않고 바로 이용 ⇒ # : 직접


## Arithmetic
- ex3.asm
    ```
            LDA     ALPHA
            ADD     INCR
            SUB     ONE
            STA     BETA
            LDA     GAMMA
            ADD     INCR
            SUB     ONE
            STA     DELTA

    ONE     WORD    1        
    ALPHA   WORD    7        .WORD: 값을 할당해서 들어있다 7
    BETA    RESW    1        .RESW: 초기화만, 값이 비어있다 0
    GAMMA   WORD    3
    DELTA   RESW    1
    INCR    RESW    1
    ```

    ```c
    int one = 1
    int alpha = 7
    int beta = 0
    int gamma = 3
    int delta = 0
    int incr = 0

    beta = 7+0-1 = 6
    gamma = 3+0-1 = 2
    ```
- ex4.asm
    ```
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
    ```

## Addressing

- #A : Immediate addressing, n=0, i=1
- @A : Indirected addressing, n=1, i=0 
⇒ **A에 저장된 값을 주소로 가지는 곳! A는 포인터, 가리키는 곳에 값을 저장 A에 저장이 아님**
- C언어 어셈블러 비교
    
    ```c
    int var = 10;
    int *addr = &var;
    *addr = 20;
    ```
    
    ```
              LDA 	  #10
              STA 	  VAR
              LDA 	  #VAR
              STA 	  ADDR
              LDA 	  #20
              STA 	  @ADDR
      
      VAR     RESW    1
      ADDR    RESW    1
    ```
    

## Flow Control - Jump, Comp
- **반복문**
    
    SIC에선 TIX ELEVEN -> X값을 1 증가시키고 ELEVEN 변수의 값과 비교해서 결과를 SW 레지스터에 저장
    
    SIC/XE에선 T레지스터를 이용해서 반복(레지스터 개수의 증가)
    
    SIC에선 string을 저장하고자 할 때 변수 2개 필요
    
- COMP, TIX
- X 레지스터
- J

```
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
```

## I/O

- **stdin(0) , stdout(1) 장치 연결. ⇒ 입력, 출력 가능**
    - input, output 한번에 1byte씩만 전송. ⇒ 여러 바이트는 반복으로 처리해야함.
    - A 레지스터 마지막 1btye 사용.
    - 2^8개 디바이스 지원
- **TD INDEV < : 준비, = :준비x**
- **RD INDEV**
- **WD INDEV**
- 콘솔에 A입력

```
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
```

## SubRoutine

- **JSUB ALPHA**
    - L 레지스터에 현재 pc값을 저장
- **RSUB**
    - JEQ랑 비슷, 기능은 거의 같은데 하나의 루틴으로 의미있음. **무한루프 가능**

```
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
```

```
          JSUB    READ        .CALL READ SUBROUTINE

                              .SUBROUTINE 100바이트 RECORD 읽기
  READ    LDX     #0          .INITIALIZE INDEX REGISTER을 0으로
          LDT     #100        .INITIALIZE T 레지스터 100으로
  RLOOP   TD      INDEV       .TEST 입력장치
          JEQ     RLOOP       .LOOP IF DEVICE IS BUSY
          RD      INDEV       .READ A 레지스터로 1바이트
          STCH    RECORD, X   .STORE RECORD로 
          TIXR    T           .ADD 1 TO INDEX REGISTER AND COMPARE NEW VALUE TO 100
          JLT     RLOOP       .LOOP INDEX VALUE가 100보다 작으면
          RSUB

  INDEV   BYTE    0           .INPUT DEVICE NUMBER
  RECORD  RESB    100         .100BYTE BUFFER FOR INPUT RECORD
```

## STACK
- JSUB 현재 지점 저장해놓고 바로 이동!
- @TOP 은 포인터!
- PUSH, POP은 TOP을 +3 -3 주소값을 바꿔준다.
```
  MAIN      START   1000
  FIRST     JSUB    STKINIT

            LDA     #1        .PUSH START
            STA     @TOP      .TOP이 가리키는 곳에 저장, TOP에 저장이 아님
            JSUB    PUSH
            LDA     #2
            STA     @TOP
            JSUB    PUSH
            LDA     #3
            STA     @TOP
            JSUB    PUSH

            JSUB    POP       .POP START
            LDA     @TOP      .포인터 값으로 넣는다
            STA     OUT1
            JSUB    POP
            LDA     @TOP
            STA     OUT2
            JSUB    POP
            LDA     @TOP
            STA     OUT3

  A         J       A         .여기서 멈춤

  STKINIT   LDA     #STACK    .STACK INIT #STACK이 주소를 가져오는거?
            STA     TOP
            RSUB

  PUSH      LDA     TOP
            ADD     #3
            STA     TOP
            RSUB

  POP       LDA     TOP
            SUB     #3
            STA     TOP
            RSUB

  OUT1      RESW    1
  OUT2      RESW    1
  OUT3      RESW    1
  TOP       RESW    1
  STACK     RESW    10000
```

## 2-demensional Array (작성중)

- 1차원으로 2차원 표현하기
- arr[2][1]  = arr + 2 * (sizeof element * sizeof Cols) + 1 * (sizeof element)
- 1개 크기 3word
- ex)

## Recursive Subroutine : Factorial (작성중)
- 피보나치 구현하기

# SicTools Linker (작성중)
- +jsub 다른곳에서 가져온다. 
```bash
# assembler 실행하기 -> obj파일 만들기
java -cp out/make/sictools.jar **sic.Asm** tests/linker/stack/main.asm 
java -cp out/make/sictools.jar **sic.Asm** tests/linker/stack/stack.asm

# linker 실행하기
java -cp out/make/sictools.jar **sic.Link** -o **out.obj** tests/linker/stack/main.obj tests/linker/stack/stack.obj
```
- main.asm
```
  main START 0
    EXTREF stinit
    EXTREF push
    EXTREF pop
    
  .init the stack at #256
    LDA #256
    +JSUB stinit

  .push 0x11 0x22 0x33 0x44 to stack
    LDA #17
    +JSUB push
    LDA #34
    +JSUB push
    LDA #51
    +JSUB push
    LDA #68
    +JSUB push
    
  .pop them back and store them to memory again
    +JSUB pop
    STA res1
    +JSUB pop
    STA res2
    +JSUB pop
    STA res3
    +JSUB pop
    STA res4
  halt J halt
    
  res1 WORD 170
  res2 WORD 170
  res3 WORD 170
  res4 WORD 170
```
- stack.asm
```
  stack START 0
    EXTDEF stinit
    EXTDEF push
    EXTDEF pop
    
  . starts the stack at the address in A
  stinit STA stackptr
    RSUB
    
  . pushes the content from A to stack
  push STA @stackptr
    LDA stackptr
    ADD #3
    STA stackptr
    RSUB
    
  .pops the top element to A
  pop LDA stackptr
    SUB #3
    STA stackptr
    LDA @stackptr
    RSUB
    
  stackptr RESW 1
    END stack
```
- main.obj
  - 링크하기전에 문자열로 되어있다. +JSUB라서 주소를 몰?루
  ```
    Hmain  0000000000**4E**
    Rpop   push  stinit
    T0000001D0101004B1000000100114B1000000100224B1000000100334B10000001
    T00001D020044
    T00001F1D4B1000004B1000000F20184B1000000F20144B1000000F20104B100000
    T00003C120F200C3F2FFD0000AA0000AA0000AA0000AA
    **M00000405+stinit
    M00000B05+push
    M00001205+push
    M00001905+push
    M00002005+push
    M00002405+pop
    M00002B05+pop
    M00003205+pop
    M00003905+pop**
    E000000
  ```
- stack.obj
  ```
    Hstack 000000000027
    Dpop   000015push  000006stinit000000
    T0000001D0F20214F00000E201B0320181900030F20124F000003200C1D00030F20
    T00001D0106
    T00001E060220034F0000
    E000000
  ```
- out.obj
  - 이제 없어졌다.
   ```
    Hout   000000000075
    T0000001D0101004B1000'4E'0100114B1000'54'0100224B1000'54'0100334B1000'54'01
    T00001D020044
    T00001F1D4B1000544B1000'63'0F20184B1000'63'0F20144B1000'63'0F20104B1000'63'
    T00003C120F200C3F2FFD0000AA0000AA0000AA0000AA
    T0000'4E'1D0F20214F00000E201B0320181900030F20124F000003200C1D00030F20
    T00006B0106
    T0000'6C'060220034F0000
    M00000405
    M00000B05
    M00001205
    M00001905
    M00002005
    M00002405
    M00002B05
    M00003205
    M00003905
    E000000
  ```