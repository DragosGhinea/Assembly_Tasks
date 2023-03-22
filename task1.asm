.data
    finalCaracter: .asciz "\n"
    formatScanf: .asciz "%s"
    sir_initial: .space 180
    lungime_sir_initial: .long 0
    instructiune: .space 180
    printfNumar: .asciz "%d "
    printfString: .asciz "%s "
    printfStringFaraSpatiu: .asciz "%s"
    formatLet: .asciz "let"
    formatAdd: .asciz "add"
    formatSub: .asciz "sub"
    formatMul: .asciz "mul"
    formatDiv: .asciz "div"
    minus: .asciz "-"
    variabila: .asciz ""

.text
.global main

main:
    pushl $sir_initial
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
    movl $sir_initial, %edi
    movl $instructiune, %esi
    xorl %ecx, %ecx

et_for_initializare:
    movb (%edi, %ecx, 1), %al 
	cmp $0, %al
	je exit

    sub $48, %al
    cmp $15, %al
    jg litera
    jmp nu_litera
litera:
    sub $7, %al
nu_litera:
    movb %al, (%esi, %ecx, 1)

    incl %ecx
	jmp et_for_initializare


exit:
    movl %ecx, lungime_sir_initial
    xorl %ecx, %ecx

et_loop:
    cmp lungime_sir_initial, %ecx
    je exit_final
    lea instructiune, %esi;

    xorl %ebx, %ebx
    xorl %eax, %eax

    jmp parcurgere

pas_loop:
    inc %ecx
    jmp et_loop

parcurgere:
    movb (%esi, %ecx, 1), %al
    shl $4, %eax
    inc %ecx
    addb (%esi, %ecx, 1), %al
    shl $4, %eax
    inc %ecx
    addb (%esi, %ecx, 1), %al


prelucrare:
    pushl %ecx

    xorl %ecx, %ecx

    movl %eax, %ecx
    shr $9, %ecx
    and $0b11, %ecx
    cmp $0, %ecx
    je numarIdentificator
    cmp $1, %ecx
    je variabilaIdentificator
    cmp $2, %ecx
    je operatieIdentificator

numarIdentificator:
    and $0b111111111, %eax

    movl %eax, %ebx
    and $0b100000000, %ebx
    cmp $0, %ebx
    je pozitiv

    pushl %eax

    pushl $minus
	pushl $printfStringFaraSpatiu
	call printf
	popl %ebx
	popl %ebx

    popl %eax
    
pozitiv:

    and $0b11111111, %eax
    pushl %eax
	pushl $printfNumar
	call printf
	popl %ebx
	popl %ebx


    jmp skipIdentificator
    
variabilaIdentificator:
    and $0b111111111, %eax
    addl %eax, variabila
    pushl %eax
    pushl $variabila
	pushl $printfString
	call printf
	popl %ebx
	popl %ebx

    popl %eax
    subl %eax, variabila



    jmp skipIdentificator
operatieIdentificator:

    and $0b111, %eax
    cmp $0, %eax
    je let_operatie
    cmp $1, %eax
    je add_operatie
    cmp $2, %eax
    je sub_operatie
    cmp $3, %eax
    je mul_operatie
    cmp $4, %eax
    je div_operatie

let_operatie:
    pushl $formatLet
    jmp skipOperatieSelect

add_operatie:
    pushl $formatAdd
    jmp skipOperatieSelect

sub_operatie:
    pushl $formatSub
    jmp skipOperatieSelect

mul_operatie:
    pushl $formatMul
    jmp skipOperatieSelect

div_operatie:
    pushl $formatDiv
    jmp skipOperatieSelect

skipOperatieSelect:
    
    pushl $printfString
	call printf
	popl %ebx
	popl %ebx

skipIdentificator:

    popl %ecx
    jmp pas_loop

exit_final:
	pushl $finalCaracter
	pushl $printfStringFaraSpatiu
	call printf
	popl %ebx
	popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
