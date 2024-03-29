global hypotenuse

extern printf
extern scanf

segment .data
	welcome db "Welcome to the Hypotenuse calculator",10,0
	inputprompt db "Enter the two sides of the triangle seperated by a space. Press enter when finished",10,0
	validateinput db "The lengths of the two sides are %lf and %lf",10,0
	showarea db "The area of the triangle is %lf",10,0
	showhypotenuse db "The hypotenuse has a length of %lf",10,0
	closing db "The module will now return the hypotenuse to the driver",10,0
	
	stringformat db "%s",0
	twofloat db "%lf %lf",0

segment .bss
;empty

segment .text

hypotenuse:

	push	rbp
	mov	rbp, rsp

;===== print welcome statements ================================================

	mov	rax, 0
	mov	rdi, stringformat
	mov	rsi, welcome
	call	printf

;===== prompt user to input two numbers ========================================

	mov	rax, 0
	mov	rdi, stringformat
	mov	rsi, inputprompt
	call	printf

;===== receive user input ======================================================

	push	qword 0
	push	qword 0
	mov 	rax, 0
	mov	rdi, twofloat
	mov	rsi, rsp		;rsi points to the first qword on the stack
	mov	rdx, rsp
	add	rdx, 8			;rdx points to the second qword on the stack
	call	scanf

	movsd	xmm12, [rsp]
	movsd	xmm13, [rsp+8]

	pop	rax			;cancel out the push on line 59
	pop	rax			;cancel out the push on line 58

;===== validate user input ====================================================

	mov	rax, 2			;indicates two floats are involved
	mov	rdi, validateinput	;"The sides are..."
	movsd	xmm0, xmm12		;do this becuase printf interacts with the "lowest" xmm registers first
	movsd	xmm1, xmm13
	call	printf

;===== Area of Triangle ========================================================

	movsd	xmm10, xmm12
	mulsd	xmm10, xmm13		;xmm10 stores base * height
	mov	rbx, 0x4000000000000000 ;hex value is 2 in decimal?
	push	rbx			;push rbx to stack to use for division
	divsd	xmm10, [rsp]		;divide base * height by 2
	pop	rax			;cancels out the push two lines above

;===== Find Hypotenuse =========================================================

	mulsd	xmm12, xmm12		;a^2
	mulsd	xmm13, xmm13		;b^2
	addsd	xmm12, xmm13		;a^2 + b^2 / store in xmm12
	sqrtsd	xmm11, xmm12		;squareroot of a^2+b^2 / store in xmm11

;===== print out the area ======================================================

	mov	rax, 1
	mov	rdi, showarea
	movsd	xmm0, xmm10
	call	printf

;===== print out the hypotenuse ================================================

	mov	rax, 1
	mov	rdi, showhypotenuse
	movsd	xmm0, xmm11
	call	printf

;===== Closing message =========================================================

	mov	rax, 1
	mov	rdi, stringformat
	mov	rdx, closing
	call	printf

;===== return everything to main.cpp ===========================================

	movsd	xmm0, xmm11
	pop    rbp

	ret
