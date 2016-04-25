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
					'Function 2: Find the number of occurrences of a certain letter', 10, 13, 
					'Function 3: The length of the string including spaces', 10, 13, '$'
functionInt		DW	?
input_buffer	DB	51
input_length	DB	?
end_buffer		DB	51 DUP('$')
datGap			DB	10, 13, '$'
character		DB  ?
; Function 1 variables
charFound		DB	'Your character was found at index $'

; Function 2 Variables
charsFound		DW	0
F2EndStatement  DB  'Your character was found $'
F2EndStatement2 DB  ' times $'

; Function 3 Variables
F3STRING1		DB	'The length of your string is $'
F3STRING2		DB  ' chars long (including spaces)$'

; Function 4 Variables
spaces			DW  0
F4STRING1		DB  ' chars long (excluding spaces)$'

; Function 5 Variables
F5STRING1		DB  'What character would you like to replace? $', 10, 13
F5STRING2		DB  'What character would you like instead? $', 10, 13
F5CharToReplace DB  ?
F5Replacement   DB  ?




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
	Call GetDec
	mov character, al
	_PutStr datGap
	
;--------------------------------------------------------------------------------
; Function Check
;--------------------------------------------------------------------------------

	cmp character, 1 
	jz  isFunction1
	cmp character, 2
	jz  isFunction2
	cmp character, 3
	jz  isFunction3
	cmp character, 4
	jz  isFunction4
	cmp character, 5
	jz  isFunction5
	
	
;--------------------------------------------------------------------------------
; Determines function of choice
;--------------------------------------------------------------------------------
FUNCTIONCHOICE:
; Function 1
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

; Function 2
isFunction2:
	_PutStr charRequest
	sGetCh echo			;Places char in AX
	
	_PutStr datGap
	mov bx, 0
	cmp end_buffer[bx], al
	jz  F2FOUND
	cmp end_buffer[bx], '$'
	jz  F2END
Function2Loop:
	inc bx
	cmp end_buffer[bx], al
	jz  F2FOUND
	cmp end_buffer[bx], '$'
	je  F2END
	
	jmp Function2Loop
	
F2END:
	_PutStr F2EndStatement
	mov ax, charsFound
	Call PutDec
	_PutStr F2EndStatement2
	jmp THEEND
	
	
	
F2FOUND:
	inc charsFound
	jmp Function2Loop
	
; Function 3
isFunction3:
	mov bx, 0
Function3Loop:
	cmp end_buffer[bx], '$'
	jz  F3FOUND
	inc bx
	jmp Function3Loop
	
F3FOUND:
	_PutStr F3STRING1
	dec bx		; bx is decremented because it is indexed starting at 0
	mov ax, bx
	Call PutDec
	_PutStr F3STRING2
	jmp THEEND

	
	
; Function 4
isFunction4:
	mov bx, 0
	cmp end_buffer[bx], '$'
	jz  F4FOUND
	cmp end_buffer[bx], ' '
	jz  F4SPACEFOUND
Function4Loop:
	inc bx
	cmp end_buffer[bx], '$'
	jz  F4FOUND
	cmp end_buffer[bx], ' '
	jz  F4SPACEFOUND
	jmp Function4Loop
	
F4SPACEFOUND:
	inc spaces
	jmp Function4Loop
	
F4FOUND:
	sub bx, spaces
	dec bx
	_PutStr F3STRING1
	mov ax, bx
	Call PutDec
	_PutStr F4STRING1
	jmp THEEND
	


; Function 5
isFunction5:
	_PutStr F5STRING1
	_GetCh echo
	mov F5CharToReplace, al
	_PutStr datGap
	_PutStr F5STRING2
	_GetCh echo
	mov F5Replacement, al
	_PutStr datGap
	mov bx, 0
	mov al, F5CharToReplace
	cmp end_buffer[bx], al
	jz  F5REPLACE
	cmp end_buffer[bx], '$'
	jz  F5END
F5LOOP:
	inc bx
	mov al, F5CharToReplace
	cmp end_buffer[bx], al
	jz  F5REPLACE
	cmp end_buffer[bx], '$'
	jz  F5END
	jmp F5LOOP
	
F5REPLACE:
	mov al, F5Replacement
	mov end_buffer[bx], al
	jmp F5LOOP
	
F5END:
	_PutStr end_buffer
	
; Function 6
isFunction6:
	mov bx, 0
	cmp end_buffer[bx], 7Ah
	jle CHECKLOWER
F6LOOP:
	inc bx
	

CHECKLOWER:
	cmp end_buffer[bx], 5Ah
	jle CHECKUPPER
	cmp end_buffer[bx], 61h
	jge F6LOWERFOUND
	jmp F6LOOP

CHECKUPPER:

THEEND:
	
	_Exit
STRINGS	ENDP
	END	STRINGS
	