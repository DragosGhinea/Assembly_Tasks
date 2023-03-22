.data
    chDelim: .asciz " "
    formatPrintf: .asciz "%d\n"
    formatScanf: .asciz "%300[^\n]"
    res: .space 4
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

    movl %eax, %esi
    xorl %eax, %eax
    xorl %ecx, %ecx
    movb (%esi, %ecx, 1), %al

cmp $115, %eax
je operatie_sub

cmp $97, %eax
je operatie_add

cmp $100, %eax
je operatie_div

cmp $109, %eax
je operatie_mul

pushl res
call atoi
popl %ebx

pushl %eax
jmp skip_operatii

operatie_sub:
    popl %eax
    popl %ebx
    subl %eax, %ebx
    pushl %ebx

    jmp skip_operatii
operatie_add:
    popl %eax
    popl %ebx
    addl %eax, %ebx
    pushl %ebx
    jmp skip_operatii
operatie_mul:
    popl %eax
    popl %ebx
    mul %ebx
    pushl %eax
    jmp skip_operatii
operatie_div:
    xorl %edx, %edx
    popl %ebx
    popl %eax
    div %ebx
    pushl %eax

skip_operatii:
	jmp et_for	

exit:
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
