TITLE Project 5     (Proj5_wiricka.asm)

; Author: Aimee Wirick
; Last Modified: 11/14/2022
; OSU email address: wiricka@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 11/20/2022
; Description: The purpose of this assignment is to reinforce concepts related to usage of the runtime stack, proper modularization practices, use of the STDCALL calling convention, use of arrays, and Indirect Operands addressing modes (CLO 3, 4, 5).
	;Using Indirect Operands, Register Indirect, and/or Base+Offset addressing
	;Passing parameters on the runtime stack
	;Generating "random" numbers
	;Working with array

INCLUDE Irvine32.inc



; Constant definitions
ARRAYSIZE =	200
LO = 15
HI = 50
.data
; variable definitions
randArray		DWORD	ARRAYSIZE DUP(?)	;DUP declaration using ARRAYSIZE as size with uninitialized values.
											;Inital ARRAYSIZE is 200 therefore Length = 200 x type DWORD(4) = size (800 Bytes)
raLength		DWORD	LENGTHOF randArray	;length of array this is used instead of ARRAYSIZE to keep the RET value the same for each call of displayList.
counts			DWORD	60 DUP(?)	;DUP declaration using 60 which accounts for the possible numbers in ranges between HI (60) and LO (5) as size with uninitialized values 
coLength		DWORD	HI-LO+1 ;length of range of possible numbers.
intro1			BYTE	"Random integer generator that sorts, counts and finds the median value.",32,32,32,"By Aimee Wirick",13,10,10,10,0 ;address offsets are (4 Bytes)
intro2			BYTE	"I am a program that generates 200 random integers between and including the numbers 15 and 50.", 10,
						"I will then display the original list, a sorted list, and the median value.",10,
						"The list will then be sorted in ascending order, and will display the count of intances of each possible",10,
						"number starting with the number of instances of the lowest possible number.",13,10,0 ;address offsets are (4 bytes)
randomTitle		BYTE	"Here is the list of generated random numbers:",13,10,10,0
sortedTitle		BYTE	"Here is the list of numbers sorted in ascending order:",13,10,10,0
medianTitle		BYTE	"This is the median number:",32,0
countsTitle		BYTE	"This list shows the number of times each number appears in the range of",10,"possible numbers between Highest possible & lowest possible starting with the lowest:",13,10,10,0
goodbye1		BYTE	"More generally the answer to everything in life is accepted to be 42.",13,0
goodbye2		BYTE	"Goodbye and have a great one!",13,10,10,0
.code
main PROC
	PUSH	OFFSET intro1		;(4 bytes address)
	PUSH	OFFSET intro2		;(4 bytes address)
	CALL	introduction		;(4 bytes return address)
	CALL	Randomize			;(4 bytes return address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	fillArray			;(4 bytes return address)
	PUSH	raLength			;(4 bytes DWORD) 
	PUSH	OFFSET randomTitle	;(4 bytes address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	displayList			;(4 bytes return address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	sortList			;(4 bytes return address)
	PUSH	OFFSET medianTitle	;(4 bytes address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	displayMedian		;(4 bytes return address)
	PUSH	raLength			;(4 bytes DWORD)
	PUSH	OFFSET sortedTitle	;(4 bytes address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	displayList			;(4 bytes return address)
	PUSH	OFFSET counts		;(4 bytes address)
	PUSH	OFFSET randArray	;(4 bytes address)
	CALL	countList			;(4 bytes return address)
	PUSH	coLength			;(4 bytes DWORD)
	PUSH	OFFSET countsTitle	;(4 bytes address)
	PUSH	OFFSET counts		;(4 bytes address)
	CALL	displayList			;(4 bytes return address)
	PUSH	OFFSET goodbye1		;(4 bytes return address)
	PUSH	OFFSET goodbye2		;(4 bytes return address)
	CALL	goodbye				;(4 bytes return address)
	Invoke ExitProcess,0		; exit to operating system
main ENDP

; description: Introduces the program and user perameters
; preconditions: intro1 and intro2 have been pushed to the stack in main
; postconditions: 
; receives: variables that have been pushed to the stack
; returns: text output to user
introduction PROC
	;preserving registers
	PUSH	EBP					;build stack frame
	MOV		EBP, ESP
	MOV		EDX, [EBP+12]		;4 push EBP, 4 CALL introduction, 4 push OFFSET intro2
	CALL	WriteString			;prints intro 1
	MOV		EDX, [EBP+8]		;4 push EBP, 4 CALL introduction
	CALL	WriteString			;prints intro 2
	CALL	CrLf
	CALL	CrLf
	;restoring registers
	POP		EBP
	RET		8					;return to main + 8 (offsets are 4 Bytes)
introduction ENDP

; description: fills the array using numbers from RandomRange
; preconditions: Randomize has been called, address for randArray is pushed, counts is pushed
; postconditions: 
; receives: variables that have been pushed to the stack and global variables HI LO and ARRAYSIZE
; returns: Array created in EDI register of random numbers
fillArray   PROC  
	;preserving registers
	PUSH    EBP				;build stack frame
	MOV     EBP,ESP
	MOV		EBX,0
	MOV     ECX,ARRAYSIZE
	MOV     EDI,[EBP+8]    ;address of array in edi  (epb +4 (epb push), +4(call return address) +4(count)
	
	MOV     EBX,0
_fillLoop:   ;loop that fills the array
	_randNum:
		MOV		EAX, HI			;puts an upper limit on our RandomRange
		ADD		EAX, 1
		CALL	RandomRange		;creates a random number within our upper limit
		CMP		EAX, LO			;compare random number to our lowest value limit
		JAE		_store			;stores our random number if it is within range
		JMP		_randNum		;creates a new number if it is not within range
	_store:
		MOV    [EDI],EAX
		ADD    EDI,4
	LOOP   _fillLoop
	
	POP     EBP
	RET     4  
fillArray   ENDP

; description: displays the numbers from left to right in order of entry
; preconditions: randArray has been pushed to stack
; postconditions: 
; receives: variable randArray that has been pushed to the stack and global variable ARRAYSIZE
; returns: text output to user of the list it has processed
displayList	PROC
	;preserving registers
	PUSH    EBP				;build stack frame
	MOV     EBP,ESP
	MOV     ESI,[EBP+8]		;address of array in ESI
	MOV		EDX,[EBP+12]	;address of title
	MOV		EBX,[EBP+16]    ;arraySize
	CALL	WriteString
	MOV		ECX, 0
	MOV     EDX,0
_showElement:
	CMP		ECX, 20
	JE		_newLine
	JMP		_continue

	_newLine:
	CALL	CrLf
	MOV		ECX, 0

	_continue:
	MOV     EAX,[ESI+EDX*4]		;start with first
	CALL    WriteDec			;display number
	MOV		AL,32
	CALL	WriteChar
	INC     EDX
	INC		ECX
	CMP     EDX,EBX				;scale ARRAYSIZE down for [count-1 down to 0]
	JL     _showElement
	CALL	CrLf
	CALL	CrLf
	CALL	CrLf
	;restoring registers
	POP     EBP
	RET     12 
displayList	ENDP

; description: Sorts randArray in ascending order
; preconditions: randArray has been pushed to stack
; postconditions: randArray has been sorted in ascending order
; receives: variable randArray that has been pushed to the stack and global variable ARRAYSIZE
; returns: a sorted randArray
sortList	PROC
;preserving registers
	PUSH    EBP				;building stack frame
	MOV     EBP,ESP
	MOV		ECX, 0			;start count at 0
	MOV		ECX, ARRAYSIZE	;arraysize in counter
	MOV		ESI, [EBP+8]	;address of array in ESI
	MOV		EDI,[EBP+8]		;address of array in EDI
	MOV		EDX, 0			;innerSort counter
_sortLoop:
	CMP		EDX, ARRAYSIZE-1
	JG		_endInnerSort	;our control to make the inner loop stop
	CMP		EDX, 0			;if pos 0
	JE		_incrementEDX
	MOV		EBX,[ESI+EDX*4] ; number in array
	DEC		EDX
	MOV		EAX,[ESI+EDX*4] ;one number lower
	INC		EDX
	CMP		EAX, EBX
	JLE		_incrementEDX
	JG		_exchangeElements
_incrementEDX:
	INC		EDX
	JMP		_loop
_exchangeElements:
	CALL		exchangeElements ;sub procedure to exchange the elements from ESI to EDI
	
_loop:
	JMP	_sortLoop
_endInnerSort:
;restoring registers
	POP     EBP
	RET     4 
sortList	ENDP

; description: Finds and displays the median number in the sorted array
; preconditions: randArray has been sorted and pushed to the stack
; postconditions: EAX contains the location in randArray where the median number is stored
; receives: variable randArray that has been pushed to the stack and global variable ARRAYSIZE
; returns: prints the median number 
displayMedian	PROC
;preserving registers
PUSH	EBP					;building stack frame
MOV		EBP, ESP
.data						;local variables for displayMedian
	lowMed		DWORD	?
	highMed		DWORD	?
	quotient	DWORD	?
	remainder	DWORD	?

.code						;code portion for displayMedian
MOV		EDX, [EBP +12]		;text string location
CALL	WriteString			;print title for displayMedian
MOV		EAX, ARRAYSIZE
CDQ
MOV		EBX, 2
IDIV	EBX
CMP		EDX, 0
JE		_evenSize

_oddSize:
MOV		ESI, [EBP + 8]		;sorted list location to ESI
MOV		EDX, EAX			;move the dividend to EDX (which is the location in the list of the Median number)
MOV		EAX, [ESI+EDX*4]	;finds the location in ESI of the median number and moves it to EAX
CALL	WriteDec			;writes the median number
CALL	CrLf
CALL	CrLf
CALL	CrLf
JMP		_end

_evenSize:
MOV		ESI, [EBP+8]		;sorted list location
MOV		EDX, EAX			;moves dividend to EDX
MOV		EBX, [ESI+EDX*4]	;moves number in EDX position from ESI to EBX
MOV		highMed, EBX		;moves higher median value to highMed
DEC		EDX					;moves to the number lower in order
MOV		EBX, [ESI+EDX*4]	;moves number in EDX position from ESI to EBX
MOV		lowMed, EBX			;moves the lower median value to lowMed
MOV		EAX, highMed		;start finding the average between the two median numbers
ADD		EAX, lowMed
CDQ
MOV		EBX, 2
IDIV	EBX		
MOV		quotient, EAX		;saves the quotient as the rounded median pending checking the remainder
MOV		remainder, EDX
IMUL	EDX, 10
MOV		EAX, EDX
CDQ
IDIV	EBX
CMP		EAX, 5				;checks the remainder against 5
JB		_printRoundedMedian	;rounds down if less than 5
INC		quotient			;rounds up if greater or equal to 5

_printRoundedMedian:
MOV		EAX, quotient		;prints rounded median
CALL	WriteDec
CALL	CrLf
CALL	CrLf
CALL	CrLf
_end:
;restoring register
POP		EBP
RET		8
displayMedian	ENDP

; description: creates a new array with spaces for all the possible numbers beween HI and LO and fills in these slots how many
;				times the numbers from randArray appear.
; preconditions: randArray has been sorted and pushed to the stack counts array is pushed to stack
; postconditions: EAX contains the location in randArray where the median number is stored
; receives: array variables that have been pushed to the stack on for source and one for destination
; returns: a new array with the counts in it 
countList		PROC
;preserving registers
PUSH	EBP				;creating stack frame
MOV		EBP, ESP
.data
repeats DWORD	0
number DWORD	LO
counterS DWORD	0		;counter for source randArray
counterD DWORD	0		;counter for destination counts array

.code
MOV		ESI, [EBP+8]	;location of randArray
MOV		EDI, [EBP+12]	;location of counts array

_outerLoop:
	MOV		EAX, number
	CMP		EAX, HI
	JA		_endLoop
	MOV		ECX, ARRAYSIZE	;counter for loop
	CountLoop:				;goes through randArray for each number in outer loop
		MOV		EAX, number	;number in we are checking for for instances of that number
		MOV		EDX, counterS ;location in randArray
		MOV		EBX, [ESI+EDX*4];number in randArray
		CMP		EAX, EBX
		JNE		_notEqual
		MOV		EAX, repeats
		INC		EAX
		MOV		repeats, EAX
		_notEqual:			;goes on to the next number
		MOV		EAX, counterS
		INC		EAX
		MOV		counterS, EAX
		LOOP  CountLoop
_storeRepeats:				;number instances are all found stores total instances in counts array and resets counters.
	MOV		EAX, repeats
	MOV		EDX, counterD
	MOV		[EDI+EDX*4], EAX
	MOV		repeats, 0
	MOV		counterS, 0
_incrementNumber:			;increments to the next possible number in the range
	MOV		EAX, number
	INC		EAX
	MOV		number, EAX
	MOV		EAX, counterD
	INC		EAX
	MOV		counterD, EAX
	JMP		_outerLoop
_endLoop:
;restoring register
POP		EBP
RET		8
countList		ENDP

; description: Exchanges the elements in EDI with the elements in EAX and EBX from ESI.
; preconditions: EAX contains a number and EBX contains the number to switch with.  ESI has been loaded and checked for correct positions.
; postconditions: EDI contains the numbers from EAX and EBX in their corrected sort order.
; receives: randArray numbers in EAX and EBX from ESI.
; returns: new array positions for the numbers in EAX and EBX that needed to move.
exchangeElements	PROC
;preserving registers
PUSH	EBP
MOV		EBP, ESP
PUSH	EAX
PUSH	EBX
;making the move
MOV		[EDI+EDX*4], EAX ;moves the number in EAX to the location EBX was previously at
DEC		EDX
MOV		[EDI+EDX*4], EBX ;moves the number in EBX to the location EAX was previously at
;restoring the registers
POP		EBX
POP		EAX
POP		EBP
RET		
exchangeElements	ENDP

; description: Says goodbye to the user
; preconditions: goodbye1 and goodbye2 have been pushed to the stack in main
; postconditions: 
; receives: variables that have been pushed to the stack
; returns: text output to user
goodbye PROC
	;preserving registers
	PUSH	EBP					;build stack frame
	MOV		EBP, ESP
	MOV		EDX, [EBP+12]		
	CALL	WriteString			;prints goodbye 1
	CALL	CrLf
	MOV		EDX, [EBP+8]		
	CALL	WriteString			;prints goodbye 2
	;restoring registers
	POP		EBP
	RET		8					;return to main + 8 (offsets are 4 Bytes)
goodbye ENDP

END main
