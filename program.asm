; Hello World in Intel Assembler

include ../pcmac.inc
.MODEL SMALL ; Small memory model
.586
.STACK 100h
.DATA
stringPrompt   	DB   'Please enter a string $'
menu			DB	'Please enter the value of the function you would like to use, ', 10, 13,
					'Function 1: First occurrence of char ', 10, 13,
					'Function 2: Find the number of occurrences of a certain letter', 10, 13, '$'
functionInt		DW	?
input_buffer	DB	51
string_buffer	DB	?
end_buffer		DB	51 DUP('$')
datGap			DB	10, 13, '$'
character		DB  ?



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
	mov 	character, ah
	jmp FUNCTIONCHOICE
	
	
;--------------------------------------------------------------------------------
; Determines function of choice
;--------------------------------------------------------------------------------
FUNCTIONCHOICE:
isFunction1:
	cmp character, 1
	mov bx, 0
	mov ax, offset character
	cmp end_buffer[bx], al
	jz  FOUND 

isFunction2:

isFunction3:

FOUND:
	
	
	_Exit
STRINGS	ENDP
	END	STRINGS
	