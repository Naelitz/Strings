; Hello World in Intel Assembler

include ../pcmac.inc
.MODEL SMALL ; Small memory model
.586
.STACK 100h
.DATA
stringPrompt   	DB   'Please enter a string $'

charRequest		DB	'What char would you like to find?   $'
menu			DB	'Please enter the value of the function you would like to use, ', 10, 13,
					'Function 1: First occurrence of char ', 10, 13,
					'Function 2: Find the number of occurrences of a certain letter', 10, 13, '$'
functionInt		DW	?
input_buffer	DB	51
string_buffer	DB	?
end_buffer		DB	51 DUP('$')
datGap			DB	10, 13, '$'
character		DB  ?
; Function 1 variables
charFound		DB	'Your character was found at index $'

; Function 2 Variables
charsFound		DW	0

; Function 3 Variables


.CODE

; ---------------------------	 UTIL.LIB Imports	 ---------------------------
EXTRN GetDec: NEAR
EXTRN PutDec: NEAR
; ------------------------------------------------------------------------------

STRINGS	PROC
	_LdSeg  ds, @data               ; Load the data segment
	_PutStr stringPrompt
	_GetStr input_buffer
	_PutStr datGap
	_PutStr menu
	sGetCh  echo		; Character is now in AX
	_PutStr datGap
	mov 	character, ah
;--------------------------------------------------------------------------------
; Function Check
;--------------------------------------------------------------------------------

	cmp character, 31h  ; Value of 1 in ascii
	je  isFunction1
	cmp character, 2
	je  isFunction2
	cmp character, 3
	je  isFunction3
	
	
;--------------------------------------------------------------------------------
; Determines function of choice
;--------------------------------------------------------------------------------
FUNCTIONCHOICE:
isFunction1:
	_PutStr charRequest
	sGetCh echo			;Places char in AX
	_PutStr datGap
	mov bx, 0
Function1Loop:
	cmp end_buffer[bx], al
	jz  F1FOUND 
	inc bx
	jmp Function1Loop
	
F1FOUND:
	_PutStr charFound
	mov ax, bx
	Call PutDec 
	jmp THEEND

isFunction2:
	_PutStr charRequest
	sGetCh echo			;Places char in AX
	_PutStr datGap
	mov bx, 0
Function2Loop:
	cmp end_buffer[bx], al
	jz  F2FOUND
	cmp end_buffer[bx], '$'
	jz  THEEND
	jmp Function2Loop
	
	
F2FOUND:
	inc charsFound
	jmp Function2Loop
	

isFunction3:

THEEND:
	
	_Exit
STRINGS	ENDP
	END	STRINGS
	