extern printf
extern scanf
extern malloc
extern free
extern exit

global main
section .text

main:
		PUSH RBP
		MOV RBP, RSP

		SUB RSP, 4											; making space for declaration


		MOV RDI, @inputIntPrompt									; get_value
		MOV RBX, -2
		CALL @getValuePrimitive


		MOV RDI, @inputIntPrompt									; get_value
		MOV RBX, -4
		CALL @getValuePrimitive

		SUB RSP, 12											; making space for declaration


		MOV AX, [RBP - 2]
		MOV BX, [RBP - 4]
		CALL @dynamicDeclCheck										; checking dynamic array declaration limits


		PUSH BX												; saving register for malloc
		PUSH AX												; saving register for malloc
		CALL malloc
		MOV [RBP - 16], RAX
		POP AX
		MOV [RBP - 6], AX
		POP BX
		MOV [RBP - 8], BX

		MOV RDI, @inputIntArrPrompt
		MOV BX, [RBP - 6]
		MOV CX, [RBP - 8]
		CALL @printGetArrPrompt

		MOV RDI, [RBP - 16]
		MOV DX, CX
		SUB DX, BX
		ADD DX, 1
		ADD DX, DX
		MOVSX RDX, DX
		CALL @getArr

		MOV AX, [RBP - 6]
		PUSH AX
		MOV BX, [RBP - 8]
		PUSH BX
		MOV RAX, [RBP - 16]
		PUSH RAX
		CALL revArr											; calling user function
		ADD RSP, 12
		MOV RDI, [RBP - 16]
		MOV CX, [RBP - 6]
		MOV DX, [RBP - 8]
		SUB DX, CX
		ADD DX, 1
		ADD DX, DX
		CALL @printIntegerArr


		MOV RDI, [RBP - 16]
		CALL free

		MOV RSP, RBP
		POP RBP
		MOV RAX, 1
		MOV RBX, 0
		INT 0x80

;--------------------------------------------------------------------------------------------------

revArr:
		PUSH RBP
		MOV RBP, RSP

		SUB RSP, 8											; making space for declaration

		MOV AX, [RBP + 26]
		MOV [RBP - 2], AX										; store variable

		MOV AX, [RBP + 24]
		MOV [RBP - 4], AX										; store variable


	WHILE1:
		MOV BX, [RBP - 2]
		PUSH BX
		MOV AX, [RBP - 4]
		PUSH AX
		POP AX
		POP BX
		CMP AX,BX
		SETG AL
		MOVSX AX, AL
		PUSH AX
		POP AX
		CMP AX, 0											; checking while loop condition
		JE WHILE2

		MOV RDI, [RBP + 16]
		MOV BX, [RBP + 26]
		MOV CX, [RBP - 2]
		MOV DX, [RBP + 24]
		CALL @boundCheck										; checking array index bound
		MOV AX, [RDI + RBX]

		MOV [RBP - 6], AX										; store variable

		MOV RDI, [RBP + 16]
		MOV BX, [RBP + 26]
		MOV CX, [RBP - 4]
		MOV DX, [RBP + 24]
		CALL @boundCheck										; checking array index bound
		MOV AX, [RDI + RBX]

		MOV [RBP - 8], AX										; store variable

		SUB RSP, 4
		MOV AX, [RBP - 8]
		PUSH AX
		MOV AX, [RBP - 6]
		PUSH AX
		CALL exch											; calling user function
		ADD RSP, 4
		POP AX
		MOV [RBP - 6], AX
		POP AX
		MOV [RBP - 8], AX

		MOV AX, [RBP - 6]
		MOV RDI, [RBP + 16]
		MOV BX, [RBP + 26]
		MOV CX, [RBP - 2]
		MOV DX, [RBP + 24]
		CALL @boundCheck										; checking array index bound
		MOV [RDI + RBX], AX										; store variable

		MOV AX, [RBP - 8]
		MOV RDI, [RBP + 16]
		MOV BX, [RBP + 26]
		MOV CX, [RBP - 4]
		MOV DX, [RBP + 24]
		CALL @boundCheck										; checking array index bound
		MOV [RDI + RBX], AX										; store variable

		MOV BX, 1
		PUSH BX
		MOV AX, [RBP - 2]
		PUSH AX
		POP AX
		POP BX
		ADD AX,BX
		PUSH AX
		POP AX
		MOV [RBP - 2], AX										; store variable

		MOV BX, 1
		PUSH BX
		MOV AX, [RBP - 4]
		PUSH AX
		POP AX
		POP BX
		SUB AX,BX
		PUSH AX
		POP AX
		MOV [RBP - 4], AX										; store variable

		JMP WHILE1

	WHILE2:

		MOV RSP, RBP
		POP RBP
		ret

;--------------------------------------------------------------------------------------------------

exch:
		PUSH RBP
		MOV RBP, RSP

		MOV AX, [RBP + 18]
		MOV [RBP + 20], AX										; store variable

		MOV AX, [RBP + 16]
		MOV [RBP + 22], AX										; store variable


		MOV RSP, RBP
		POP RBP
		ret

;--------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------

@boundCheck:
		CMP CX, BX
		JGE .leftLim
		CALL @boundERROR

	.leftLim:
		CMP DX, CX
		JGE .rightLim
		CALL @boundERROR

	.rightLim:
		SUB CX, BX
		ADD CX, CX
		MOVSX RBX, CX

		ret

@dynamicDeclCheck:
		CMP AX, 0
		JGE .leftNotNeg
		CALL @declNegERROR

	.leftNotNeg:
		CMP BX, 0
		JGE .rightNotNeg
		CALL @declNegERROR

	.rightNotNeg:
		CMP BX, AX
		JGE .dynChecked
		CALL @declERROR

	.dynChecked:
		MOV DX, BX
		SUB DX, AX
		ADD DX, 1
		ADD DX, DX
		MOVSX RDI, DX

		ret

@getValuePrimitive:
		XOR RSI, RSI
		XOR RAX, RAX
		PUSH RBX
		CALL printf
		POP RBX

		MOV RAX, RSP
		AND RAX, 15
		ADD RAX, 8
		SUB RSP, RAX
		PUSH RAX
		MOV RDI, @inputInt										; get_value
		MOV RSI, RSP
		SUB RSI, 16
		PUSH RBX
		PUSH RSI
		CALL scanf
		POP RSI
		POP RBX
		MOV AX, [RSP - 16]
		MOV [RBP + RBX], AX

		POP RAX
		ADD RSP, RAX

		ret

@printGetArrPrompt:
		MOV SI, CX
		SUB SI, BX
		ADD SI, 1
		MOVSX RSI, SI
		XOR RAX, RAX
		PUSH BX
		PUSH CX
		CALL printf
		POP CX
		POP BX

		MOV RDI, @leftRange
		MOVSX RSI, BX
		XOR RAX, RAX
		PUSH BX
		PUSH CX
		CALL printf
		POP CX
		POP BX

		MOV RDI, @rightRange
		MOVSX RSI, CX
		XOR RAX, RAX
		PUSH BX
		PUSH CX
		CALL printf
		POP CX
		POP BX

		ret

@getArr:
		MOV RAX, RSP
		AND RAX, 15
		ADD RAX, 8
		SUB RSP, RAX
		PUSH RAX

		PUSH RDI
		MOV RCX, 0

	.getArrLoop:								; getting array
		MOV RDI, @inputInt
		MOV RSI, RSP
		SUB RSI, 24
		PUSH RCX
		PUSH RDX
		PUSH RSI
		CALL scanf
		POP RSI
		POP RDX
		POP RCX
		MOV RBX, RCX
		MOV AX, [RSP - 24]
		POP RDI
		PUSH RDI
		MOV [RDI + RBX], AX

		ADD RCX, 2
		CMP RCX, RDX
		JNE .getArrLoop

		POP RDI
		POP RAX
		ADD RSP, RAX

		ret

@printIntegerArr:
		PUSH RDI
		MOV RDI, @printFormatArray
		XOR RSI, RSI
		XOR RAX, RAX
		PUSH DX
		CALL printf
		POP DX
		POP RDI

		MOV CX, 0

	.printArr:
		PUSH RDI
		MOVSX RBX, CX
		MOV SI, [RDI + RBX]
		MOV RDI, @printInt
		MOVSX RSI, SI
		XOR RAX, RAX
		PUSH CX
		PUSH DX
		CALL printf
		POP DX
		POP CX
		POP RDI

		ADD CX, 2
		CMP CX, DX
		JNE .printArr

		MOV RDI, @printNewLine
		XOR RSI, RSI
		XOR RAX, RAX
		CALL printf

		ret

@boundERROR:
		MOV RDI, @boundPrint
		XOR RSI, RSI
		XOR RAX, RAX
		CALL printf
		MOV EDI, 0
		CALL exit

@declERROR:
		MOV RDI, @declPrint
		XOR RSI, RSI
		XOR RAX, RAX
		CALL printf
		MOV EDI, 0
		CALL exit

@declNegERROR:
		MOV RDI, @declNeg
		XOR RSI, RSI
		XOR RAX, RAX
		CALL printf
		MOV EDI, 0
		CALL exit

;--------------------------------------------------------------------------------------------------

section .data
		@boundPrint : db "RUNTIME ERROR : Array out of bounds" , 10, 0
		@declPrint : db "RUNTIME ERROR : Invalid order of bounds in dynamic array declaration" , 10, 0
		@declNeg : db "RUNTIME ERROR : Negative bound in dynamic array declaration" , 10, 0
		@printFormatArray : db "Output : " , 0
		@printInt : db "%d ", 0
		@printNewLine : db 10, 0
		@inputIntPrompt : db "Enter an integer : " , 0
		@inputIntArrPrompt : db "Enter %d array elements of integer type for range ", 0
		@leftRange : db "%d to " , 0
		@rightRange : db "%d" ,10, 0
		@inputInt : db "%d", 0
