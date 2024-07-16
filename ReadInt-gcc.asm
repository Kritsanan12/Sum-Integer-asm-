section .data
format db "%d" ,0
printInt db "Your integer is : %d" , 0
section .note.GNU-stack noalloc noexec nowrite progbits

section .bss
integer resb 4 ; reserve 4 byte

section .text
extern scanf
extern printf
global main

main:
;call scanf
push rbp
mov rbp ,rsp

lea rdi,[format]
lea rsi,[integer]
xor eax,eax
call scanf
mov eax,[integer]

lea rdi , [printInt]
mov esi , eax
xor eax , eax
call printf
EndProcess:
mov rsp , rbp
pop rbp
xor eax,eax
ret
