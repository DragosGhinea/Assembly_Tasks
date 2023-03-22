.data
    fr: .space 200
    ul: .space 200
    s: .space 400
    n: .space 4
    m: .space 4
    res: .space 4
    lungime: .space 4
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    terminatorPrintf: .asciz "\n"

.text

afisare:
    pushl %ebp
    movl %esp, %ebp

    xorl %ecx, %ecx
    for_afisare:
        cmp %ecx, lungime
        je final_for_afisare

        pushl %ecx

        movl (%esi, %ecx, 4), %ecx
        pushl %ecx
        pushl $formatPrintf
        call printf
        popl %ecx
        popl %ecx

        popl %ecx

        incl %ecx
        jmp for_afisare

    final_for_afisare:
        pushl $terminatorPrintf
        call printf
        popl %ecx
        jmp exit

    popl %ebp
    ret

valid:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl 8(%ebp), %edx

    movl (%esi, %edx, 4), %ebx
    movl (%edi, %ebx, 4), %ecx
    cmp $3, %ecx
    je return_0

    pushl %edi
    movl $ul, %edi

    movl (%edi, %ebx, 4), %ecx
    cmp $-1, %ecx
    
    popl %edi
    je return_1

    subl %ecx, %edx
    cmp m, %edx
    jle return_0

    return_1:
    movl $1, %eax
    jmp final_valid

    return_0:
    movl $0, %eax

    final_valid:
    popl %ebx
    popl %ebp
    ret

back:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx


    movl 8(%ebp), %edx

    cmp %edx, lungime
    jne nu_e_final_back

    call afisare

    jmp final_back

    nu_e_final_back:

    cmp $0, (%esi, %edx, 4)
    je back_liber

    movl (%esi, %edx, 4), %eax

    pushl %edi
    movl $ul, %edi

    movl (%edi, %eax, 4), %ecx
    cmp $-1, %ecx
    
    popl %edi
    je recursie_back

    pushl %edx
    subl %ecx, %edx
    cmp m, %edx
    popl %edx
    jg recursie_back

    jmp final_back

    recursie_back:

        pushl %esi
        movl $ul, %esi
        
        movl (%esi, %eax, 4), %ebx
        movl %edx, (%esi, %eax, 4)

        popl %esi

        pushl %eax
        pushl %ecx
        pushl %edx

        incl %edx
        pushl %edx
        call back
        popl %edx

        popl %edx
        popl %ecx
        popl %eax


        pushl %esi
        movl $ul, %esi

        movl %ebx, (%esi, %eax, 4)

        popl %esi

        jmp final_back

    back_liber:

    xorl %ecx, %ecx
    incl %ecx

    for_back:
        cmp %ecx, n
        jl final_for_back

        movl %ecx, (%esi, %edx, 4)

        pushl %edx
        pushl %ecx

        pushl %edx
        call valid
        popl %edx

        popl %ecx
        popl %edx

        cmp $0, %eax
        je  final_pas_for_back


    recursie_back2:
        pushl %esi
        movl $ul, %esi

        incl (%edi, %ecx, 4)
        
        movl (%esi, %ecx, 4), %ebx
        movl %edx, (%esi, %ecx, 4)

        popl %esi

        pushl %ecx
        pushl %edx

        incl %edx
        pushl %edx
        call back
        popl %edx

        popl %edx
        popl %ecx


        pushl %esi
        movl $ul, %esi

        decl (%edi, %ecx, 4)
        movl %ebx, (%esi, %ecx, 4)

        popl %esi

    final_pas_for_back:
        movl $0, (%esi, %edx, 4)

        incl %ecx
        jmp for_back

    final_for_back:

    final_back:
    popl %ebx
    popl %ebp
    ret

citire:
    pushl %ebp
    movl %esp, %ebp

    pushl $n
    pushl $formatScanf
    call scanf
    popl %ecx
    popl %ecx

    pushl $m
    pushl $formatScanf
    call scanf
    popl %ecx
    popl %ecx

    xorl %edx, %edx
    movl n, %eax
    movl $3, %ebx
    mull %ebx
    movl %eax, lungime

    xorl %eax, %eax

    xorl %ecx, %ecx
    for_citire:
        cmp %ecx, lungime
        je final_for_citire

        pushl %ecx

        pushl %ebp
        pushl $formatScanf
        call scanf
        popl %ecx
        popl %ecx

        popl %ecx

        movl 0(%ebp), %eax

        cmp $0, %eax
        je sari_atribuire

        movl %eax, (%esi, %ecx, 4)
        incl (%edi, %eax, 4)

        sari_atribuire:

        incl %ecx
        jmp for_citire

    final_for_citire:

    pushl %esi
    movl $ul, %esi

    xorl %ecx, %ecx
    incl %ecx
    for_citire_2:
    cmp %ecx, n
    jl final_for_citire2

    movl $-1, (%esi, %ecx, 4)

    incl %ecx
    jmp for_citire_2
    final_for_citire2:

    popl %esi

    popl %ebp
    ret

.global main

main:
    lea fr, %edi
    lea s, %esi

    call citire

    pushl $0
    call back
    popl %ebx

    pushl $-1
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    pushl $terminatorPrintf
    call printf
    popl %ebx

exit:

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
