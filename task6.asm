.data
    input_fila: .asciz "sudoku.in"
    output_fila: .asciz "sudoku.out"
    invalid_str: .asciz "Fara solutii"
    res: .space 4
    chDelim: .asciz " \n"
    spatiu: .asciz " "
    terminator: .asciz "\n"
    cifraSudoku: .asciz "0"
    sudoku: .space 400

.bss
    fd_out: .space 1
    fd_in:  .space 1
    info: .space  200

.text

citire:

    pushl %ebp
    movl %esp, %ebp

    movl $5, %eax
    movl $input_fila, %ebx
    movl $0, %ecx
    movl $0777, %edx
    int $0x80

    mov %eax, fd_in

    movl $3, %eax
    movl fd_in, %ebx
    movl $info, %ecx
    movl $200, %edx
    int $0x80

    movl $6, %eax
    movl fd_in, %ebx
    int $0x80

    pushl $chDelim
	pushl $info
	call strtok 
	popl %ebx
	popl %ebx

    pushl %eax
    call atoi
    popl %ebx

    xorl %ecx, %ecx

    movl %eax, (%edi, %ecx, 4)
    
    incl %ecx
    for_citire:
        cmp $81, %ecx
        jge final_for_citire

        pushl %ecx

        pushl $chDelim
	    pushl $0
	    call strtok 
	    popl %ebx
	    popl %ebx

        pushl %eax
        call atoi
        popl %ebx

        popl %ecx

        movl %eax, (%edi, %ecx, 4)

        incl %ecx
        jmp for_citire

    final_for_citire:

    popl %ebp
    ret

afisare:

    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl $8, %eax
    movl $output_fila, %ebx
    movl $0777, %ecx
    int $0x80

    mov %eax, fd_out

    //interior fila

    xorl %ecx, %ecx
    
    for_linie_afisare:
    cmp $81, %ecx
    je final_for_afisare


    xorl %edx, %edx
    for_coloana_afisare:
        cmp $8, %edx
        je final_for_coloana_afisare
        pushl %edx
        pushl %ecx

        mov (%edi, %ecx, 4), %ebx

        pushl %ebx

        movl $1, %edx
        addb %bl, cifraSudoku
        mov $cifraSudoku, %ecx
        mov fd_out, %ebx
        movl $4, %eax
        int $0x80

        popl %ebx
        subb %bl, cifraSudoku

        movl $1, %edx
        mov $spatiu, %ecx
        mov fd_out, %ebx
        movl $4, %eax
        int $0x80

        popl %ecx
        popl %edx

        incl %edx
        incl %ecx
        jmp for_coloana_afisare

    final_for_coloana_afisare:

    pushl %ecx

    mov (%edi, %ecx, 4), %ebx

    pushl %ebx

    movl $1, %edx
    addb %bl, cifraSudoku
    mov $cifraSudoku, %ecx
    mov fd_out, %ebx
    movl $4, %eax
    int $0x80

    popl %ebx
    subb %bl, cifraSudoku

    movl $1, %edx
    mov $terminator, %ecx
    mov fd_out, %ebx
    movl $4, %eax
    int $0x80

    popl %ecx

    incl %ecx
    jmp for_linie_afisare

    final_for_afisare:

    //sfarsit interior fila
    movl $6, %eax
    mov fd_out, %ebx
    int $0x80

    popl %ebx
    popl %ebp
    ret

valid:

    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl $0
    pushl $0

    movl 8(%ebp), %eax
    movl $9, %ebx
    mul %ebx

    xorl %ecx, %ecx
    

    movl 16(%ebp), %edx
    
    for_linie_valid:
        cmp $9, %ecx
        je final_for_linie_valid

        pushl %eax
        addl %ecx, %eax
        cmp (%edi, %eax, 4), %edx
        popl %eax
        je return_0_valid

        incl %ecx
        jmp for_linie_valid
    
    final_for_linie_valid:

    movl 12(%ebp), %eax
    
    xorl %ecx, %ecx
    for_coloana_valid:
        cmp $81, %ecx
        je final_for_coloana_valid

        pushl %eax
        addl %ecx, %eax
        cmp (%edi, %eax, 4), %edx
        popl %eax
        je return_0_valid

        addl $9, %ecx
        jmp for_coloana_valid

    final_for_coloana_valid:


    xorl %edx, %edx

    movl 8(%ebp), %eax
    movl $3, %ebx
    div %ebx
    movl 8(%ebp), %eax
    subl %edx, %eax
    movl %eax, -8(%ebp)

    xorl %edx, %edx

    movl 12(%ebp), %eax
    movl $3, %ebx
    divl %ebx
    movl 12(%ebp), %eax
    subl %edx, %eax
    movl %eax, -12(%ebp)

    movl 16(%ebp), %edx

    xorl %ecx, %ecx
    for_1_patrat_valid:
        cmp $3, %ecx
        je final_for_1_patrat_valid

        xorl %ebx, %ebx

        for_2_patrat_valid:
            cmp $3, %ebx
            je final_for_2_patrat_valid
            
            pushl %ecx

            movl -8(%ebp), %eax
            addl %ecx, %eax
            movl $9, %ecx
            mul %ecx

            addl %ebx, %eax
            addl -12(%ebp), %eax
            
            popl %ecx

            movl 16(%ebp), %edx
            cmp (%edi, %eax, 4), %edx
            je return_0_valid
           
            incl %ebx
            jmp for_2_patrat_valid

        final_for_2_patrat_valid:

        incl %ecx
        jmp for_1_patrat_valid

    final_for_1_patrat_valid:

    jmp return_1_valid

return_0_valid:
    movl $0, %eax
    jmp final_valid

return_1_valid:

    movl $1, %eax

final_valid:
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebp
    ret

rezolvaSudoku:

    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    cmp $8, 8(%ebp)
    jne sari_if_1_rezolvare

    cmp $9, 12(%ebp)
    jne sari_if_1_rezolvare

    jmp return_1_rezolvare

    sari_if_1_rezolvare:

    cmp $9, 12(%ebp)
    jne sari_if_2_rezolvare

    incl 8(%ebp)
    movl $0, 12(%ebp)

    sari_if_2_rezolvare:

    movl 8(%ebp), %eax
    movl $9, %ebx
    mul %ebx
    addl 12(%ebp), %eax
    cmp $0, (%edi, %eax, 4)
    jle sari_if_3_rezolvare

    pushl %ecx
    pushl %edx
    incl 12(%ebp)

    push 12(%ebp)
    push 8(%ebp)
    call rezolvaSudoku
    popl %ebx
    popl %ebx

    decl 12(%ebp)
    popl %edx
    popl %ecx
    jmp final_rezolvare

    sari_if_3_rezolvare:

    xorl %ecx, %ecx
    incl %ecx

    for_rezolvare:
        cmp $9, %ecx
        jg final_for_rezolvare

        pushl %ecx
        pushl %edx

        pushl %ecx
        pushl 12(%ebp)
        pushl 8(%ebp)
        call valid
        popl %ecx
        popl %ecx
        popl %ecx

        popl %edx
        popl %ecx

        cmp $0, %eax
        je sari_if_for_rezolvare

        movl 8(%ebp), %eax
        movl $9, %ebx
        mul %ebx
        addl 12(%ebp), %eax

        movl %ecx, (%edi, %eax, 4)

        pushl %ecx
        pushl %edx
        incl 12(%ebp)

        push 12(%ebp)
        push 8(%ebp)
        call rezolvaSudoku
        popl %ebx
        popl %ebx

        decl 12(%ebp)
        popl %edx
        popl %ecx

        cmp $0, %eax
        je sari_if_for_rezolvare

        jmp return_1_rezolvare

        sari_if_for_rezolvare:

        movl 8(%ebp), %eax
        movl $9, %ebx
        mul %ebx
        addl 12(%ebp), %eax
        movl $0, (%edi, %eax, 4)

        incl %ecx
        jmp for_rezolvare
    final_for_rezolvare:

    return_0_rezolvare:
        movl $0, %eax
        jmp final_rezolvare

    return_1_rezolvare:
        movl $1, %eax

    final_rezolvare:
    popl %ebx
    popl %ebp
    ret

.global main
main:
    lea sudoku, %edi

    call citire

    pushl $0
    pushl $0
    call rezolvaSudoku
    popl %ebx
    popl %ebx

    cmp $0, %eax
    je fara_solutii

    call afisare

    jmp exit
    
    fara_solutii:

    movl $8, %eax
    movl $output_fila, %ebx
    movl $0777, %ecx
    int $0x80

    mov %eax, fd_out

    //interior fila
	
    movl $12, %edx
    mov $invalid_str, %ecx
    mov fd_out, %ebx
    movl $4, %eax
    int $0x80

    //sfarsit interior fila
    movl $6, %eax
    mov fd_out, %ebx
    int $0x80

exit:

movl $1, %eax
xorl %ebx, %ebx
int $0x80
