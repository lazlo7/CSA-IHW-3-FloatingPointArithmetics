	.file	"prog.c"
	.intel_syntax noprefix
	.text
	.globl	func
	.type	func, @function
func:
	push	rbp
	mov	rbp, rsp
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	QWORD PTR -16[rbp], xmm1
	movsd	QWORD PTR -24[rbp], xmm2
	movsd	xmm0, QWORD PTR -24[rbp]
	movapd	xmm1, xmm0
	mulsd	xmm1, xmm0
	movsd	xmm0, QWORD PTR -16[rbp]
	divsd	xmm0, xmm1
	addsd	xmm0, QWORD PTR -8[rbp]
	pop	rbp
	ret
	.size	func, .-func
	.globl	simpson_approximate
	.type	simpson_approximate, @function
simpson_approximate:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	QWORD PTR -16[rbp], xmm1
	movsd	xmm0, QWORD PTR -16[rbp]
	subsd	xmm0, QWORD PTR -8[rbp]
	movsd	xmm1, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -24[rbp], xmm0
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movapd	xmm2, xmm1
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	func
	movsd	QWORD PTR -32[rbp], xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
	addsd	xmm0, QWORD PTR -16[rbp]
	movsd	xmm1, QWORD PTR .LC1[rip]
	movapd	xmm4, xmm0
	divsd	xmm4, xmm1
	movapd	xmm1, xmm4
	movsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movapd	xmm2, xmm1
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	func
	movsd	xmm1, QWORD PTR .LC2[rip]
	mulsd	xmm0, xmm1
	movapd	xmm5, xmm0
	addsd	xmm5, QWORD PTR -32[rbp]
	movsd	QWORD PTR -32[rbp], xmm5
	movsd	xmm1, QWORD PTR -16[rbp]
	movsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movapd	xmm2, xmm1
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	func
	addsd	xmm0, QWORD PTR -32[rbp]
	mulsd	xmm0, QWORD PTR -24[rbp]
	leave
	ret
	.size	simpson_approximate, .-simpson_approximate
	.section	.rodata
.LC3:
	.string	"Enter a and b (a <= b): "
.LC4:
	.string	"%lf"
	.align 8
.LC5:
	.string	"Error: a must be less than or equal to b"
	.align 8
.LC7:
	.string	"Error: a and b must not be equal to 0"
.LC8:
	.string	"Result: %lf\n"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	lea	rdi, .LC3[rip]
	call	puts@PLT
	lea	rax, -24[rbp]
	mov	rsi, rax
	lea	rdi, .LC4[rip]
	mov	eax, 0
	call	__isoc99_scanf@PLT
	lea	rax, -16[rbp]
	mov	rsi, rax
	lea	rdi, .LC4[rip]
	mov	eax, 0
	call	__isoc99_scanf@PLT
	movsd	xmm0, QWORD PTR -24[rbp]
	movsd	xmm1, QWORD PTR -16[rbp]
	comisd	xmm0, xmm1
	jbe	.L17
	lea	rdi, .LC5[rip]
	call	puts@PLT
	mov	eax, 1
	jmp	.L13
.L17:
	movsd	xmm0, QWORD PTR -24[rbp]
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jp	.L16
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	je	.L9
.L16:
	movsd	xmm0, QWORD PTR -16[rbp]
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jp	.L11
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	jne	.L11
.L9:
	lea	rdi, .LC7[rip]
	call	puts@PLT
	mov	eax, 1
	jmp	.L13
.L11:
	movsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -24[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	simpson_approximate
	lea	rdi, .LC8[rip]
	mov	eax, 1
	call	printf@PLT
	mov	eax, 0
.L13:
	mov	rdx, QWORD PTR -8[rbp]
	xor	rdx, QWORD PTR fs:40
	je	.L14
	call	__stack_chk_fail@PLT
.L14:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1075314688
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	1074790400
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
