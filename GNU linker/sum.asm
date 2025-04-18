section .data
    newline db 0xa
    Prompt1Msg db "Enter a first number: " , 
    Prompt1MsgLen equ $ - Prompt1Msg
    ResultMsg db "Result: " , 
    ResultMsgLen equ $ - ResultMsg
    Prompt2Msg db "Enter a second number: " , 
    Prompt2MsgLen equ $ - Prompt2Msg
section .bss
    AtoiBuffer resb 12
    ItoaBuffer resb 12
    ResultBuffer resb 12
section .text
    global _start
_start:
    push Prompt1MsgLen
    push Prompt1Msg
    call Print
    call Read
    push AtoiBuffer
    call atoi
    mov [ResultBuffer] , eax
    
    push Prompt2MsgLen
    push Prompt2Msg
    call Print
    call Read
    push AtoiBuffer
    call atoi
    add eax , [ResultBuffer]
    push eax 
    call itoa
    push ResultMsgLen
    push ResultMsg
    call Print
    push 12
    push ItoaBuffer
    call Print
    call Newline

EndProcess:
    mov eax , 1
    int 0x80
atoi:
    push ebp
    mov ebp , esp
    sub esp , 16

    mov DWORD [ebp-8] , 0 ; result
    mov DWORD [ebp-12] , 1 ; sign

    mov esi , [ebp+8]
atoi.whitespace:
    cmp byte [esi] , ' '
    jne atoi.notwhitespace
    inc esi 
    jmp atoi.whitespace
atoi.notwhitespace:
    jmp atoi.sign
atoi.sign:
    cmp byte [esi] , '-'
    je atoi.negative
    cmp byte [esi] , '+'
    je atoi.positive
    
    jmp atoi.convert
atoi.negative:
    mov DWORD [ebp-12] , -1 ; sign = -1
    inc esi
    jmp atoi.convert
atoi.positive:
    mov DWORD [ebp-12] , 1
    inc esi
atoi.convert:
    movzx eax , byte [esi] ; load the character into eax
    test al , al ; check if it's null terminator
    jz atoi.apply_sign

    cmp al , '0'
    jl atoi.apply_sign ; if less than '0', done
    cmp al , '9'
    jg atoi.apply_sign ; if greater than '9', done

    sub eax , '0' ; (*str - '0');
    mov edx , [ebp-8] ; load result
    imul edx , 10 ; result *= 10
    add edx , eax ; result += digit
    mov [ebp-8] , edx ; store result
    inc esi ; move to next character
    jmp atoi.convert
atoi.apply_sign:

    mov eax , [ebp-8]
    imul eax , DWORD [ebp-12] ; result *= sign
    add esp , 16 ; clear stack
    mov esp , ebp
    pop ebp
    ret
itoa:
    push ebp
    mov ebp , esp
    sub esp , 16

    mov DWORD [ebp-8] , 0 ;i
    mov DWORD [ebp-12] , 0 ;isNegative
    mov esi , ItoaBuffer

    mov eax , [ebp+8]
    cmp eax , 0 
    jne itoa.notzero

    mov eax , [ebp-8]
    mov byte [esi+eax] , '0'
    inc DWORD [ebp-8]
    mov eax, [ebp-8]
    mov byte [esi+eax] , 0
    jmp return

itoa.notzero:
    mov eax , [ebp+8] ;eax = num
    cmp eax , 0
    jg itoa.loop
    inc DWORD [ebp-12] ; isNegative = 1
    neg DWORD [ebp+8] ; num = -num
   
    mov esi , ItoaBuffer
itoa.loop:
    mov eax, [ebp+8] ;eax = num
    cmp eax , 0
    je itoa.loop.end

    mov ecx , 10 ; %10
    xor edx , edx ; clear edx
    div ecx ; eax = num / 10
    add dl , '0' ; convert to char
    mov edi , [ebp-8] ; i
    mov [esi+edi] , dl ; buffer[i] = num % 10
    inc DWORD [ebp-8] ; i++
    mov [ebp+8] , eax ; num = num / 10
    jmp itoa.loop
itoa.loop.end:
    mov esi , ItoaBuffer
    mov eax, [ebp-8]
    mov byte [esi+eax] , 0 ; buffer[i] = 0
    mov eax, [ebp-12] ; check if isNegative
    cmp eax, 0
    je itoa.reverse
    mov eax, [ebp-8] ; i
    mov byte [esi+eax], '-' ; prepend '-'
    inc DWORD [ebp-8] ; i++
itoa.reverse:
    mov ecx, 0 ; j = 0 
    mov eax, [ebp-8] ; i
    dec eax ; k = i-1
itoa.reverse.loop:
    cmp ecx ,eax 
    jge return
    movzx ebx, byte [esi + ecx] 
    movzx edx, byte [esi + eax]
    mov [esi + ecx], dl 
    mov [esi + eax], bl
    inc ecx
    dec eax
    jmp itoa.reverse.loop
return:
    add esp , 16
    pop ebp
    ret
Print:
    push ebp
    mov ebp , esp
    sub esp , 16

    mov eax , 4
    mov ebx , 1
    mov ecx , [ebp+8]
    mov edx , [ebp+12]
    int 0x80
    
    mov eax , [ebp+16]
    cmp eax , 'n'
    je Print.newline
    
    add esp , 16
    mov esp , ebp
    pop ebp
    ret
Read:
    push ebp
    mov ebp , esp
    sub esp , 16

    mov eax , 3
    mov ebx , 0
    mov ecx , AtoiBuffer
    mov edx , 12
    int 0x80

    add esp , 16
    mov esp , ebp
    pop ebp
    ret
Print.newline:
    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx , 1
    int 0x80

    add esp , 16
    mov esp , ebp
    pop ebp
    ret
Newline:
    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx , 1
    int 0x80
    ret
