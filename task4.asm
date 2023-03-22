.data
    finalCaracter: .asciz "\n"
    printfStringFaraSpatiu: .asciz "%s"
    linii: .space 4
    coloane: .space 4
    totalElemente: .space 4
    matrice: .space 1600
    indexL: .space 4
    indexC: .space 4
    formatScanf: .asciz "%300[^\n]"
    formatPrintf: .asciz "%d "
    chDelim: .asciz " "
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

    pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl %eax
    call atoi
    popl %ebx

    movl %eax, linii

    pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl %eax
    call atoi
    popl %ebx

    movl %eax, coloane

    //final nr coloane

    xorl %ecx, %ecx
    movl linii, %ebx
    mul %ebx
    movl %eax, totalElemente

    lea matrice, %esi
	
et_for:

    pushl %ecx

	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    popl %ecx

    cmp %ecx, totalElemente
	je final_citire

    pushl %ecx

    pushl %eax
    call atoi
    popl %ebx

    popl %ecx

    movl %eax, (%esi, %ecx, 4)


    inc %ecx
    jmp et_for

final_citire:

	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl %eax
    call atoi
    popl %ebx

    cmp $0, %eax
    je operatie_rotate

    pushl %eax

    pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    movl %eax, %edi
    xorl %eax, %eax
    xorl %ecx, %ecx
    movb (%edi, %ecx, 1), %al

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
    popl %edi
    xorl %ecx, %ecx
    for_sub:
        cmp %ecx, totalElemente
        je skip_operatii

        movl (%esi, %ecx, 4), %eax
        subl %edi, %eax
        movl %eax, (%esi, %ecx, 4)

        inc %ecx
        jmp for_sub
operatie_add:
    popl %edi
    xorl %ecx, %ecx
    for_add:
        cmp %ecx, totalElemente
        je skip_operatii

        movl (%esi, %ecx, 4), %eax
        addl %edi, %eax
        movl %eax, (%esi, %ecx, 4)

        inc %ecx
        jmp for_add
operatie_mul:
    popl %edi
    xorl %ecx, %ecx
    for_mul:
        xorl %edx, %edx
        cmp %ecx, totalElemente
        je skip_operatii

        movl (%esi, %ecx, 4), %eax
        imul %edi
        movl %eax, (%esi, %ecx, 4)

        inc %ecx
        jmp for_mul
operatie_div:
    popl %edi
    xorl %ecx, %ecx
    for_div:
        xorl %edx, %edx
        cmp %ecx, totalElemente
        je skip_operatii

        movl (%esi, %ecx, 4), %eax

        cmp $0, %eax
        jge div_pozitiv

        not %eax
        inc %eax

        pushl %edi

        not %edi
        inc %edi

        idiv %edi
        movl %eax, (%esi, %ecx, 4)
        
        popl %edi

        inc %ecx
        jmp for_div

        div_pozitiv:

        idiv %edi
        movl %eax, (%esi, %ecx, 4)

        inc %ecx
        jmp for_div

operatie_rotate:
    xorl %ecx, %ecx
    stiva_rotate:
        cmp %ecx, totalElemente
        je reatribuire
        pushl (%esi, %ecx, 4)

        inc %ecx
        jmp stiva_rotate

    reatribuire:
        movl linii, %edi
        movl coloane, %ebx
        movl %edi, coloane #//edx=coloane
        movl %ebx, linii #//ebx=linii

        movl %ebx, %eax #//atribui linii
        subl $1, %eax #//scad 1 sa am linii-1
        mul %edi #//inmultesc cu nr de elemente
        subl $1, %eax

        muta_linia:
            inc %eax
            cmp %eax, totalElemente
            je skip_operatii

        xorl %ecx, %ecx
        movl %eax, %ecx
        atribuire_coloana:
            cmp $0, %ecx
            jl muta_linia

            popl %edx
            movl %edx, (%esi, %ecx, 4)

            subl coloane, %ecx
            jmp atribuire_coloana

skip_operatii:

    pushl linii
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    pushl coloane
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

xorl %ecx, %ecx
afisare_matrice:
    
    cmp %ecx, totalElemente
    je exit

    pushl %ecx

    movl (%esi, %ecx, 4), %eax
    pushl %eax
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    popl %ecx

    inc %ecx
    jmp afisare_matrice

exit:
	pushl $finalCaracter
	pushl $printfStringFaraSpatiu
	call printf
	popl %ebx
	popl %ebx


    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
