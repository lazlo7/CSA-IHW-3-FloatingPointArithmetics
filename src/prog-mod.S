	// Название исходника на C.
	.file	"prog.c"

	// Инте-синтаксис.
	.intel_syntax noprefix
	.text

	// Объявление функции func.
	.globl	func
	.type	func, @function
func:
	push	rbp
	mov	rbp, rsp

	// Первый аргумент - double a (8 байт): xmm0 (128-битный регистр).
	// Оставляем в регситре xmm0.
	// movsd	QWORD PTR -8[rbp], xmm0

	// Второй аргумент - double b (8 байт): xmm1 (128-битный регистр).
	// Оставляем в регситре xmm1.
	// movsd	QWORD PTR -16[rbp], xmm1
	
	// Третий аргумент - double x (8 байт): xmm2 (128-битный регистр).
	// Оставляем в регситре xmm2.
	// movsd	QWORD PTR -24[rbp], xmm2

	// Используем дополнительно два регистра xmm3 и xmm6 для промежуточных результатов.
	// xmm3 = x
	movsd xmm3, xmm2
	// xmm3 = x^2
	mulsd xmm3, xmm3
	// xmm6 = b
	movsd xmm6, xmm1
	// xmm6 = b / x^2
	divsd xmm6, xmm3
	// xmm3 = a
	movsd xmm3, xmm0
	// xmm3 = a + b / x^2
	addsd xmm3, xmm6

	// Возвращаем double результат (64-бита) в xmm0 (128-бит).
	movsd xmm0, xmm3

	pop	rbp
	ret

	.size	func, .-func

	.globl	simpson_approximate
	.type	simpson_approximate, @function
simpson_approximate:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32

	// Первый аргумент - double a (8 байт): xmm0 (128-битный регистр).
	// Будем хранить значение из xmm0 в неиспользуемом регистре xmm4. 
	// movsd	QWORD PTR -8[rbp], xmm0
	movsd xmm4, xmm0

	// Второй аргумент - double b (8 байт): xmm1 (128-битный регистр).
	// Будем хранить значение из xmm1 в неиспользуемом регистре xmm5.
	// movsd	QWORD PTR -16[rbp], xmm1
	movsd xmm5, xmm1

	// Используем дополнительно xmm5, xmm7, xmm8, xmm9, xmm10 для промежуточных результатов.

	// xmm2 = a
	movsd xmm2, xmm4
	// xmm7 = func(a, b, a).
	call	func
	movsd xmm7, xmm0

	// xmm2 = b
	movsd xmm2, xmm5
	// xmm0 = xmm4
	movsd xmm0, xmm4
	// xmm8 = func(a, b, b).
	call	func
	movsd xmm8, xmm0

	// xmm2 = a
	movsd xmm2, xmm4
	// xmm2 = a + b.
	addsd xmm2, xmm5
	// QWORD PTR .LC1[rip] - константа double 2.0. 
	// xmm10 = 2.
	movsd xmm10, QWORD PTR .LC1[rip]
	// xmm2 = (a + b) / 2.
	divsd xmm2, xmm10

	// xmm0 = xmm4
	movsd xmm0, xmm4
	// xmm9 = func(a, b, (a + b) / 2).
	call	func
	movsd xmm9, xmm0

	// QWORD PTR .LC2[rip] - константа double 4.0.
	// xmm10 = 4
	movsd xmm10, QWORD PTR .LC2[rip]
	// xmm9 = 4 * func(a, b, (a + b) / 2).
	mulsd xmm9, xmm10

	// xmm7 = func(a, b, a) + 4 * func(a, b, (a + b) / 2).
	addsd xmm7, xmm9
	// xmm7 = func(a, b, a) + 4 * func(a, b, (a + b) / 2) + func(a, b, b).
	addsd xmm7, xmm8

	// QWORD PTR .LC0[rip] - константа double 6.0.
	// xmm10 = 6.
	movsd xmm10, QWORD PTR .LC0[rip]
	// xmm7 = (func(a, b, a) + 4 * func(a, b, (a + b) / 2) + func(a, b, b)) / 6.
	divsd xmm7, xmm10

	// xmm8 = b - a.
	movsd xmm8, xmm5
	subsd xmm8, xmm4

	// xmm7 = (b - a) * (func(a, b, a) + 4 * func(a, b, (a + b) / 2) + func(a, b, b)) / 6.
	mulsd xmm7, xmm8

	// Возвращаем double результат (64-бита) в xmm0 (128-бит).
	movsd xmm0, xmm7

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

	// Объявляем функцию main.
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32

	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	
	// printf("Enter a and b (a <= b): \n");
	lea	rdi, .LC3[rip]
	call	puts@PLT
	
	// rsi - адрес double a.
	lea	rsi, -24[rbp]
	// rdi - адрес формат-строки "%lf".
	lea	rdi, .LC4[rip]
	// eax = 0 - больше нет аргументов.
	mov	eax, 0
	call	__isoc99_scanf@PLT

	// rsi - адрес double b.
	lea	rsi, -16[rbp]
	// rsi - адрес формат-строки "%lf".
	lea	rdi, .LC4[rip]
	// eax = 0 - больше нет аргументов.
	mov	eax, 0
	call	__isoc99_scanf@PLT

	// xmm0 = double a.
	movsd	xmm0, QWORD PTR -24[rbp]

	// xmm1 = double b.
	movsd	xmm1, QWORD PTR -16[rbp]
	
	// COMISD — Compare Scalar Ordered Double-Precision Floating-Point Values and Set EFLAGS.
	comisd	xmm0, xmm1

	// пргыаем, если a < b.
	jbe	.L17

	// printf("Error: a must be less than or equal to b\n");
	lea	rdi, .LC5[rip]
	call	puts@PLT

	mov	eax, 1
	jmp	.L13

.L17:
	movsd	xmm0, QWORD PTR -24[rbp]

	// pxor - логическое xor.
	pxor	xmm1, xmm1
	// UCOMISD — Unordered Compare Scalar Double-Precision Floating-Point Values and Set EFLAGS.
	ucomisd	xmm0, xmm1

	// прыгаем если PF = 1.
	jp	.L16

	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	// прыгаем, если a == 0.
	je	.L9

.L16:
	movsd	xmm0, QWORD PTR -16[rbp]
	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1

	// прыгаем, если PF = 1.
	jp	.L11

	pxor	xmm1, xmm1
	ucomisd	xmm0, xmm1
	// прыгаем, если b != 0.
	jne	.L11

.L9:
	// printf("Error: a and b must not be equal to 0\n");
	lea	rdi, .LC7[rip]
	call	puts@PLT

	mov	eax, 1
	jmp	.L13

.L11:
	movsd	xmm0, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -24[rbp]

	// xmm1 = b.
	movapd	xmm1, xmm0
	// xmmo = a.
	movq	xmm0, rax
	call	simpson_approximate

	// print("Result: %lf\n");
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
