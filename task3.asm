.data
    chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
    formatPrintfD: .asciz "Debug: %d\n"
    formatScanf: .asciz "%300[^\n]"
    formatPrintfC: .asciz "Debug S: %c\n"
	res: .space 4
    variabile: .space 124
    str: .space 120
.text

.global main

main:

    pushl $str
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    xorl %eax, %eax
    xorl %ecx, %ecx
    xorl %edx, %edx

	pushl $chDelim
	pushl $str
	call strtok 
	popl %ebx
	popl %ebx
	
	movl %eax, res
    jmp interior_for
	
et_for:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
	
	cmp $0, %eax
	je exit

    movl %eax, res

interior_for:

    pushl %eax

    pushl res
    call atoi
    popl %ebx

    cmp $0, %eax

    movl %eax, %edi
    popl %eax

    jne numar_gasit

    movl %eax, %esi
    xorl %eax, %eax
    xorl %ecx, %ecx
    inc %ecx
    movb (%esi, %ecx, 1), %al
    xorl %ecx, %ecx
    cmp $0, %eax
    je variabila_gasita

    movl %eax, %edx
    movb (%esi, %ecx, 1), %al

cmp $108, %eax
je operatie_let

    lea variabile, %esi
    movl %eax, %edi

    popl %eax #//bool al doilea nr
    popl %ebx #//al doilea numar
    popl %ecx #//bool primu numar
    popl %edx #//primu numar

    //este variabila
    cmp $0,%eax
    jne transform_variabila1

    jmp sfarsit_transform_variabila1

transform_variabila1:

    movl (%esi, %ebx, 4), %ebx


sfarsit_transform_variabila1:
    cmp $0,%ecx
    jne transform_variabila2

    jmp sfarsit_transform_variabila2

transform_variabila2:

    movl (%esi, %edx, 4), %edx

sfarsit_transform_variabila2:

    pushl %edx
    pushl %ebx

    movl %edi, %eax


cmp $115, %eax
je operatie_sub

cmp $97, %eax
je operatie_add

cmp $100, %eax
je operatie_div

cmp $109, %eax
je operatie_mul

numar_gasit:

    pushl %edi
    pushl $0
    jmp skip_operatii

variabila_gasita:
    movb (%esi, %ecx, 1), %al
    subl $97, %eax
    pushl %eax
    pushl $1

jmp skip_operatii

operatie_sub:
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    pushl $0

    jmp skip_operatii
operatie_add:
    popl %eax
    popl %ebx
    addl %eax, %ebx
    pushl %ebx
    pushl $0
    jmp skip_operatii
operatie_mul:
    popl %eax
    popl %ebx
    mul %ebx
    pushl %eax
    pushl $0
    jmp skip_operatii
operatie_div:
    xorl %edx, %edx
    popl %ebx
    popl %eax
    div %ebx
    pushl %eax
    pushl $0
    jmp skip_operatii
operatie_let:
	popl %eax #//bool al doilea nr
    popl %ebx #//al doilea nr
    popl %ecx #//bool prim numar (mereu 1)
    popl %edx #//prima adresa


    lea variabile, %esi

    cmp $0, %eax
    jne variabila_let
    
    movl %ebx, (%esi, %edx, 4)

    jmp skip_operatii
variabila_let:
    movl (%esi, %ebx, 4), %ecx
    movl %ecx, (%esi, %edx, 4)


skip_operatii:
	jmp et_for	

exit:
    popl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80

