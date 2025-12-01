; ADD 3 DIGIT LONG NUMBERS
; BY ALESSANDRA MENDOZA AND DYLAN CHEN
; INSPIRED BY ELEANOR MAHSHEI AND ALEX HAMILL
; Library from Gabe <3

; Character codes - CR (0DH = 13): Moves cursor to beginning of line
; LF (0AH = 10): Moves cursor down one line
; Together they create a "new line" in CP/M (similar to \r\n in Windows)
CR	EQU	0DH
LF	EQU	0AH

; BDOS Function Numbers - these are function codes passed to BDOS (the CP/M operating system)
RCONF	EQU	1      ; Read character from console (keyboard)
WCONF	EQU	2      ; Write character to console (screen)
RBUFF	EQU	10     ; Read buffered line from console

INITF	EQU	13
OPENF	EQU	15     ; Open existing file
CLOSF	EQU	16     ; Close file
FINDF	EQU	17
DELEF	EQU	19
READF	EQU	20     ; Read 128-byte record
WRITF	EQU	21     ; Write 128-byte record
MAKEF	EQU	22     ; Create new file
SDMAF	EQU	26     ; Set DMA (Direct Memory Access) address

; Memory Locations
RBOOT	EQU	0
BDOS	EQU	5      ; Jump to BDOS at address 0005H
DRIVE	EQU	0
MEMAX	EQU	7      ; Maximum memory page
TFCB	EQU	5CH    ; Default File Control Block location
FCBTY	EQU	TFCB+9
FCBEX	EQU	TFCB+12
FCBS2	EQU	TFCB+14
FCBRC	EQU	TFCB+15
FCBCR	EQU	TFCB+32
TBUFF	EQU	80H    ; Default disk transfer buffer (128 bytes)

; Return codes
BDAOK	EQU	0      ; Success
BDER1	EQU	1      ; EOF (normal end)
BDER2	EQU	2
BDERR	EQU	255    ; Error

TPA	EQU	100H   ; Transient Program Area (where your program loads)
ORG	0100H

START:  LXI     SP,STAK        ; Load stack pointer - sets SP to STAK, giving 64 bytes of stack space

; MAIN PROGRAM - ADD TWO 3-DIGIT NUMBERS
MAIN:   CALL    TWOCR           ; DOUBLE SPACE - Print two blank lines
        CALL    SPMSG           ; Stack Pointer Message - prints inline string
        DB      'ADD 3 Digit Numbers',0
        CALL    TWOCR

        ; GET FILE
        CALL    SPMSG
        DB      'ENTER FILENAME: ',0
        CALL    CIMSG           ; Console Input Message - reads buffered line from keyboard
        CALL    CCRLF
        CALL    LOADFCBFROMINPUT ; Parse filename into FCB format (8 char name + 3 char ext, space-padded)
        CALL    SHOFN           ; Show the filename
        CALL    GET             ; Read entire file into BUFFER

        ; GET TWO LINES
        ; LINE ONE
        LXI     H,BUFFER        ; Point HL to start of file data
        CALL    READLINE        ; Find first line, null-terminate it
        SHLD    NUM1STR            ; SAVE FIRST NUMBER - save pointer to "123\0"

        ; LINE TWO
        CALL    READLINE        ; Find second line, null-terminate it
        SHLD    NUM2STR            ; SAVE SECOND NUMBER - save pointer to "456\0"

        ; CONVERT STR TO INT
        LHLD    NUM1STR         ; Load pointer to first number string
        CALL    ATOI            ; Convert ASCII string to 16-bit integer in HL
        SHLD    NUM1            ; Store integer value

        LHLD    NUM2STR         ; Load pointer to second number string
        CALL    ATOI            ; Convert ASCII string to 16-bit integer in HL
        SHLD    NUM2            ; Store integer value

        ; ADD THE NUMBERS
        LHLD    NUM1            ; LOAD FIRST NUMBER
        XCHG                    ; MOVE TO DE - swap HL and DE registers
        LHLD    NUM2            ; LOAD SECOND NUMBER
        DAD     D               ; HL = HL + DE - "Double ADD" performs 16-bit addition
        SHLD    RESULT          ; SAVE RESULT

        ; DISPLAY RESULT - BUILDING OUTPUT FILE
        ;clear outbuf first
        LXI     H,OUTBUF
        LXI     D,1024
CLROUT:
        MVI     M,0             ; Clear buffer byte by byte
        INX     H
        DCX     D
        MOV     A,D
        ORA     E
        JNZ     CLROUT

        LXI     H,OUTBUF
        SHLD    OUTPTR          ; Initialize output pointer to start of buffer

        ; COPY INPUTTED LINES
        LHLD    NUM1STR
        MOV     D,H
        MOV     E,L
        CALL    APPENDLINE      ; Copy first number string and add CR+LF

        LHLD    NUM2STR
        MOV     D,H
        MOV     E,L
        CALL    APPENDLINE      ; Copy second number string and add CR+LF

        ; ADD "---" FOR AESTHETICS
        LXI     D,DASHES
        CALL    APPENDLINE      ; Add separator line

        ; APPEND RESULTS
        LHLD    RESULT          ; Load result integer
        CALL    ITOATOTMP       ; Convert integer to ASCII string in TMPNUM
        LXI     D,TMPNUM
        CALL    APPENDLINE      ; Add result string and CR+LF

        ;NULL-TERMINATE
        LHLD    OUTPTR
        MVI     M,0             ; Add null terminator at end of output

        ;WRITE OUTPUT FILE
        CALL    SPMSG
        DB      'OUTPUT FILENAME: ',0
        CALL    CIMSG           ; Get output filename from user
        CALL    CCRLF
        CALL    LOADFCBFROMINPUT ; Parse output filename into FCB
        CALL    BUILDOUTPUTFILE  ; Write OUTBUF to disk as 128-byte CP/M records

        JMP     RBOOT           ; Exit to CP/M

; Read one line from buffer at HL, null-terminate it, return pointer to start
READLINE:
        ;HL = ADDRESS IN BUFFER
        SHLD    TMPPTR          ;SAVE STARTIN TXT LOC - save starting position

RL1:
        MOV     A,M             ; A = byte at address HL
        ORA     A               ; Set flags (checks if A == 0)
        JZ      RLEND           ; If null byte, we're done
        CPI     CR              ; Compare A with CR (0DH)
        JZ      RLCR            ; Found end of line!
        CPI     LF              ; Compare A with LF (0AH)
        JZ      RLCR            ; Found end of line!
        INX     H               ; HL = HL + 1 (next character)
        JMP     RL1             ; Keep scanning

RLCR:
        MVI     M,0             ; Replace CR/LF with null terminator
        INX     H               ; Move past it
RLEND:
        LHLD    TMPPTR          ; Restore start pointer
        RET                     ; Return with HL pointing to start of null-terminated line

;CONVERT ASCII STRING TO HL
; RETURNS VALUE IN HL
; Uses "Horner's method" for base-10 conversion
; Example: "123" -> integer 123
ATOI:
        LXI     D,0             ; CLEAR RESULT IN DE - DE = 0 (our accumulator)

A1:     MOV     A,M             ; GET CHARACTER
        ORA     A               ; CHECK FOR END - check if null terminator
        JZ      A2           ; DONE IF ZERO
        CPI     '0'             ; CHECK IF DIGIT - is it >= '0' (48)?
        JC      A3          ; SKIP IF NOT - if less, skip (not a digit)
        CPI     '9'+1           ; Is it <= '9' (57)?
        JNC     A3          ; SKIP IF NOT - if greater, skip (not a digit)

        ; MULTIPLY DE BY 10
        ; The 8080 has no multiply instruction!
        ; DE * 10 = (DE * 2 * 2 + DE) * 2
        ; Uses only addition (DAD)
        PUSH    H               ; SAVE POINTER - save string pointer
        PUSH    D               ; SAVE CURRENT RESULT
        MOV     H,D             ; COPY DE TO HL
        MOV     L,E
        DAD     H               ; HL = DE * 2
        DAD     H               ; HL = DE * 4
        POP     D               ; RESTORE ORIGINAL DE
        PUSH    D               ; SAVE IT AGAIN
        DAD     D               ; HL = DE * 5
        DAD     H               ; HL = DE * 10
        POP     D               ; CLEAN UP STACK
        XCHG                    ; RESULT TO DE - DE = DE * 10

        ; ADD DIGIT TO RESULT
        ; Handles 16-bit addition with carry propagation
        POP     H               ; RESTORE POINTER
        MOV     A,M             ; GET DIGIT CHARACTER
        SUI     '0'             ; CONVERT TO BINARY - e.g., '3' -> 3
        ADD     E               ; ADD TO LOW BYTE
        MOV     E,A
        MVI     A,0
        ADC     D               ; ADD CARRY TO HIGH BYTE
        MOV     D,A

A3:     INX     H               ; NEXT CHARACTER
        JMP     A1

A2:     XCHG                    ; RESULT TO HL
        RET

; CONVERT INT IN HL TO TMPNUM (NULL-TERMINATED) 
; Example: Converting 579 to "579"
; Generates digits backwards, then reverses string
ITOATOTMP:
        PUSH    B
        PUSH    D
        LXI     B,TMPNUM        ; Point to output buffer
        PUSH    B               ; Save start address
ITOA1:
        ;DIVIDE HL BY 10 - Division by repeated subtraction (no divide instruction!)
        ; Keep subtracting 10 until HL < 10
        ; Count subtractions in BC (quotient)
        ; Remainder in HL is the digit
        PUSH    B               ; Save output pointer
        LXI     B,0             ; BC WILL HOLD RESULT - BC = quotient counter
ITOA2:  
        MOV     A,H             ; Check high byte first
        ORA     A
        JNZ     ITOASUB         ; High byte not zero, definitely >= 10
        MOV     A,L
        CPI     10
        JC      ITOA3           ; HL < 10, we have remainder
ITOASUB:
        LXI     D,10
        MOV     A,L
        SUB     E               ; Subtract 10 from HL
        MOV     L,A
        MOV     A,H
        SBB     D
        MOV     H,A

        INX     B               ; BC++ (count how many times we subtracted)
        JMP     ITOA2
ITOA3:
        MOV     A,L             ; A = remainder (the digit)
        ADI     '0'             ; Convert to ASCII
        POP     D               ; Get output pointer
        STAX    D               ; Store digit character
        INX     D
        PUSH    D               ; Save updated pointer

        MOV     H,B             ; HL = quotient (BC)
        MOV     L,C

        MOV     A,H
        ORA     L

        POP     B
        JNZ      ITOA1          ; Continue if quotient != 0
        
ITOA4:
        MVI     A,0
        STAX    B               ; Null-terminate string

        POP     D               ; DE = start of string
        DCX     B               ; BC = end of string (before null)
; String reversal - swap characters from ends moving inward
REV1:
        MOV     A,C
        SUB     E               ; Check if BC <= DE
        JC      REV2            ; Done reversing
        JZ      REV2

        MOV     A,B
        CMP     D
        JC      REV2

        LDAX    D               ; H = *DE
        MOV     H,A
        LDAX    B               ; A = *BC
        STAX    D               ; *DE = *BC (swap characters)
        MOV     A,H
        STAX    B               ; *BC = H

        INX     D               ; DE++ (move inward from start)
        DCX     B               ; BC-- (move inward from end)
        JMP     REV1
REV2:
        POP     D
        POP     B
        RET

;APPEND STRING AT DE TO OUTBUF
;OUTPTR UPDATED
; Copies string character by character, adds CR+LF at end
APPENDLINE:
        LHLD    OUTPTR          ; HL = current write position in OUTBUF
AL1:
        LDAX    D               ; A = character from source string
        ORA     A               ; Check if null terminator
        JZ      AL2             ; Done copying
        MOV     M,A             ; Write character to output buffer
        INX     H               ; Next output position
        INX     D               ; Next source character
        JMP     AL1             ; Continue loop
AL2:
        MVI     M,CR            ; Add carriage return
        INX     H
        MVI     M,LF            ; Add line feed
        INX     H
        SHLD    OUTPTR          ; Update write position
        RET

;READ FILENAME FROM INBUFF
; CP/M filenames: 8 characters for name + 3 for extension, all space-padded
; Example: "DATA.TXT" becomes "DATA    TXT"
LOADFCBFROMINPUT:
        LXI     H,INBUF+2       ; Skip first 2 bytes of input buffer
        LXI     D,TFCB+1        ; FCB byte 0 is drive, start at byte 1
        MVI     C,8             ; Copy up to 8 filename characters
COPYNAME:
        MOV     A,M             ; Get character from input
        ORA     A               ; Null terminator?
        JZ      PADNAME         ; Yes, pad rest with spaces
        CPI     '.'             ; Period?
        JZ      SKIPDOT         ; Yes, done with filename
        MOV     A,M
        STAX    D               ; Copy to FCB
        INX     H               ; Next input character
        INX     D               ; Next FCB position
        DCR     C               ; Decrement counter
        JNZ     COPYNAME        ; Continue if not 8 chars yet
        JMP     NAMEDONE
PADNAME:
        MVI     A,' '           ; Space character
PADNAMELOOP:
        STAX    D               ; Write space to FCB
        INX     D
        DCR     C
        JNZ     PADNAMELOOP     ; Pad until 8 characters total
NAMEDONE:
        MOV     A,M
        CPI     '.'
        JNZ     STARTEXT        ; No dot found, assume no extension
SKIPDOT:
        INX     H               ; Skip the '.'
STARTEXT:
        MVI     C,3             ; 3 characters for extension
COPYEXT:
        MOV     A,M
        ORA     A               ; Null?
        JZ      PADEXT
        CPI     CR              ; Carriage return?
        JZ      PADEXT
        CPI     LF              ; Line feed?
        JZ      PADEXT

        MOV     A,M
        STAX    D               ; Copy extension character to FCB
        INX     H
        INX     D
        DCR     C
        JNZ     COPYEXT
        JMP     EXTDONE
PADEXT:
        MVI     A,' '
PADEXTLOOP:
        STAX    D
        INX     D
        DCR     C
        JNZ     PADEXTLOOP
EXTDONE:
        RET


;WRITE OUTBUF TO OUTPUT FILE
; CP/M Requirement: Files must be written in 128-byte records (sectors)
BUILDOUTPUTFILE:
        LHLD    OUTPTR          ; HL = end of actual data
        LXI     D,OUTBUF+128    ; DE = one record (128 bytes) past start

; Pad to 128-byte boundary with EOF markers if needed
PADREC:
        MOV     A,H
        CMP     D               ; Compare high bytes
        JNZ     PADLOOP
        MOV     A,L
        CMP     E               ; Compare low bytes
        JNZ     PADDONE         ; Haven't reached 128-byte boundary
PADLOOP:
        MVI     M,1AH           ; CP/M EOF character (Control-Z)
        INX     H
        MOV     A,H
        CMP     D
        JNZ     PADLOOP
        MOV     A,L
        CMP     E
        JC      PADLOOP         ; Keep padding until boundary
PADDONE:
        LXI     H,OUTBUF
        SHLD    NEXT            ; Save buffer start
        LXI     D,TFCB
        MVI     C,MAKEF         ; Function 22: Create file (or overwrite existing)
        CALL    BDOS
        
        LHLD    NEXT
        XCHG                    ; DE = buffer address
        MVI     C,SDMAF         ; Function 26: Set DMA Address - tells CP/M where to read data from
        CALL    BDOS
        
        LXI     D,TFCB
        MVI     C,WRITF         ; Function 21: Write record - writes 128 bytes from DMA address to disk
        CALL    BDOS

        MVI     C,CLOSF         ; Function 16: Close file - finalizes directory entry and flushes buffers
        LXI     D,TFCB
        CALL    BDOS

        RET

DONE:   RET


; STORAGE FOR NUMBERS
TMPNUM: DS      8       ; Temporary string for number conversion
TMPPTR: DS      2       ; Temporary pointer (2 bytes = 16-bit address)

NUM1STR:    DW  0       ; Pointer to first number string in BUFFER
NUM2STR:    DW  0       ; Pointer to second number string in BUFFER

NUM1:   DW      0       ; First number as 16-bit integer (0-65535)
NUM2:   DW      0       ; Second number as 16-bit integer
RESULT: DW      0       ; Sum result (16-bit)
OUTPTR: DW      0       ; Current write position in OUTBUF

NUM1TXT:    DW  0
NUM2TXT:    DW  0

ITOACNT:    DW  0
HLTEMP:     DW  0

DASHES: DB '-', '-', '-', '-', 0  ; Separator line for output

INBUF:  DS  128         ; Keyboard input buffer
BUFFER: DS  1024        ; File input buffer (8 records)
OUTBUF: DS  1024        ; File output buffer (8 records)

; Show filename in FCB format (e.g., "A:FILENAME.EXT")
SHOFN:	PUSH	B
	PUSH	H
	LDA	FCBTY
	MOV	C,A
	XRA	A
	STA	FCBTY
	STA	FCBEX
	LXI	H,TFCB
	MOV	A,M
	ANI	0FH
	ORI	40H
	CALL	CO              ; Display drive letter
	MVI	A,':'
	CALL	CO
	INX	H
	CALL	COMSG           ; Display filename
	MOV	A,C
	LXI	H,FCBTY
	MOV	M,A
	MVI	A,'.'
	CALL	CO
	CALL	COMSG           ; Display extension
	POP	H
	POP	B
	RET

REMSG:	CALL	TWOCR
	LXI	H,RERROR
	CALL	COMSG
	RET

WEMSG:	CALL	TWOCR
	LXI	H,WERROR
	CALL	COMSG
	RET

WROPN:	CALL	TWOCR
	LXI	H,OPERROR
	CALL	COMSG
	RET

CPDMA:	LXI	D,TBUFF
	MVI	C,SDMAF
	CALL	BDOS
	RET

DRSEL:	CALL	CIMSG
	LDA	INBUF+2
	ANI	01011111B
	SUI	'@'
	JM	DRERR
	SUI	17
	JP	DRERR
	ADI	17
	RET

DRERR:	XRA	A
	RET

; Read entire file into BUFFER
; Opens file, reads all 128-byte records until EOF or out of memory
GET:	LXI	H,BUFFER
	SHLD	NEXT            ; NEXT tracks current position
	LXI	D,TFCB
	MVI	C,OPENF         ; Function 15: Open file
	CALL	BDOS
	CPI	BDERR           ; 255 = error
	JNZ	GET1
	CALL	TWOCR
	LXI	H,OPERROR
	CALL	COMSG           ; "CANNOT_OPEN"
	CALL	SHOFN           ; Show filename
ERREX:	CALL	TWOCR
	CALL	CO
	JMP	DONE

GET1:	XRA	A               ; A = 0
	STA	RECCT           ; Record count = 0

GET2:	LHLD	NEXT
	XCHG                    ; DE = current buffer position
	MVI	C,SDMAF         ; Set DMA address
	CALL	BDOS
	LXI	D,TFCB
	MVI	C,READF         ; Function 20: Read record
	CALL	BDOS
	CPI	BDAOK           ; 0 = success
	JZ	GET3
	CPI	BDER1           ; 1 = EOF (normal end)
	JZ	GETEX
	LXI	H,RERROR        ; Read error
	CALL	COMSG
	JMP	ERREX

GET3:	LDA	RECCT
	INR	A               ; Increment record count
	STA	RECCT
	LHLD	NEXT
	LXI	D,128           ; One record size
	DAD	D               ; NEXT += 128
	SHLD	NEXT
	LDA	MEMAX           ; Maximum memory page
	DCR	A
	CMP	H               ; Check if out of memory
	JNZ	GET2            ; Continue reading
	CALL	TWOCR
	LXI	H,MEMERROR      ; Out of memory
	CALL	COMSG
	JMP	ERREX

GETEX:	CALL	CCRLF
	CALL	CPDMA
	RET

PUT:	LXI	H,BUFFER
	SHLD	NEXT
	LDA	RECCT
	STA	CTSAV
	LDA	TFCB
	ORA	A
	JNZ	PUT1
	LXI	H,OPERROR
	CALL	COMSG
	JMP	PUTEX

PUT1:	MVI	C,INITF
	CALL	BDOS
	XRA	A
	STA	FCBCR
	LXI	H,0
	SHLD	FCBEX
	SHLD	FCBS2
	LXI	D,TFCB
	MVI	C,FINDF
	CALL	BDOS
	CPI	BDERR
	JZ	PUT2
	CALL	CCRLF
	LXI	H,ERAMSG
	CALL	COMSG
	CALL	SHOFN
	CALL	GETYN
	JNZ	PUTEX
	LXI	D,TFCB
	MVI	C,DELEF
	CALL	BDOS

PUT2:	LXI	D,TFCB
	MVI	C,MAKEF
	CALL	BDOS
	CPI	BDERR
	JNZ	PUT3
	LXI	H,OPERROR
	CALL	COMSG
	JMP	PUTEX

PUT3:	LHLD	NEXT
	XCHG
	MVI	C,SDMAF
	CALL	BDOS
	LHLD	NEXT
	LXI	D,128
	DAD	D
	SHLD	NEXT
	LXI	D,TFCB
	MVI	C,WRITF
	CALL	BDOS
	CPI	BDAOK
	JZ	PUT4
	LXI	H,WERROR
	CALL	COMSG
	JMP	PUTEX

PUT4:	LDA	RECCT
	DCR	A
	STA	RECCT
	JNZ	PUT3
	CALL	CPDMA
	LXI	D,TFCB
	MVI	C,CLOSF
	CALL	BDOS
	LDA	CTSAV
	STA	RECCT

PUTEX:	CALL	CCRLF
	CALL	CPDMA
	RET

; Console Input - reads one character from keyboard
; ANI 7FH strips high bit (parity bit on some terminals)
CI:	PUSH	B               ; Save all registers
	PUSH	D
	PUSH	H
	MVI	C,RCONF         ; Function 1: Read character
	CALL	BDOS
	ANI	7FH             ; Strip high bit (parity)
	POP	H               ; Restore registers
	POP	D
	POP	B
	RET                     ; Return character in A

; Console Output - displays character in A to screen
CO:	PUSH	B
	PUSH	D
	PUSH	H
	MVI	C,WCONF         ; Function 2: Write character
	MOV	E,A             ; BDOS expects character in E
	CALL	BDOS
	POP	H
	POP	D
	POP	B
	RET

TWOCR:	CALL	CCRLF

CCRLF:	MVI	A,CR            ; Carriage return
	CALL	CO
	MVI	A,LF            ; Line feed
	CALL	CO
	RET

; Display null-terminated string pointed to by HL
COMSG:	MOV	A,M             ; Get character from HL
	ORA	A               ; Check for null
	RZ                      ; Return if zero
	CALL	CO              ; Display character
	INX	H               ; Next character
	JMP	COMSG           ; Loop

; MESSAGE POINTED TO BY STACK OUT TO CONSOLE
; Brilliant inline string printing!
; When CALL SPMSG executes, return address points to the string
; XTHL pops this into HL, characters are printed while incrementing HL
; When null found, HL points past the string, XTHL puts this back on stack
; RET returns to code AFTER the string
SPMSG:  XTHL                    ; GET "RETURN ADDRESS" TO HL - exchange top of stack with HL
        XRA     A               ; CLEAR FLAGS AND ACCUMULATOR
        ADD     M               ; GET ONE MESSAGE CHARACTER
        INX     H               ; POINT TO NEXT
        XTHL                    ; RESTORE STACK FOR - restore stack, save updated address
        RZ                      ; RETURN IF DONE
        CALL    CO              ; ELSE DISPLAY CHARACTER
        JMP     SPMSG           ; AND DO ANOTHER

; Read buffered line from console with editing (backspace, etc.)
; INBUF Structure:
;   Byte 0: max length (80)
;   Byte 1: actual length entered
;   Byte 2+: the actual string
CIMSG:	PUSH	B
	PUSH	D
	PUSH	H
	LXI	H,INBUF+1
	MVI	M,0             ; Clear length byte
	DCX	H
	MVI	M,80            ; Set max length to 80
	XCHG                    ; DE = INBUF
	MVI	C,RBUFF         ; Function 10: Read buffered line
	CALL	BDOS
	LXI	H,INBUF+1
	MOV	E,M             ; E = actual length
	MVI	D,0             ; DE = length
	DAD	D               ; HL = INBUF + 1 + length
	INX	H               ; Point past last character
	MVI	M,0             ; Null-terminate string
	POP	H
	POP	D
	POP	B
	RET

GETYN:	
	LXI	H,YNMSG
	CALL	COMSG
	CALL	CIMSG
	CALL	CCRLF
	LDA	INBUF+2
	ANI	01011111B
	CPI	'Y'
	RZ
	CPI	'N'
	JNZ	GETYN
	CPI	0
	RET

DRSAV:	DS	1
RECCT:	DS	1
CTSAV:	DS	1
NEXT:	DS	2

	DS	64             ; 64 bytes of stack space
STAK:	DB	0           ; Stack grows downward TO here (8080 stack grows downward)

SINON:	DB	'YOUR SIGN ON MESSAGE',0

RERROR:	DB	'READ ERROR',0
WERROR:	DB	'WRITE ERROR',0
OPERROR:	DB	'CANNOT_OPEN',0
MEMERROR:	DB	'OUT OF MEMORY',0
ERAMSG:	DB	'OK TO ERASE',0
YNMSG:	DB	'Y/N?: ',0

    END