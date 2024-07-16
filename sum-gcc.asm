section .data 
format db "%d" , 0
output db "Sum : %d " , 10 ,0
section .note.GNU-stack noalloc noexec nowrite progbits
section .bss
a resd 1 ;reserve 4 byte for int because int size is 4 byte
b resd 1 ;reserve 4 byte for int 
section .text
extern scanf ; import scanf for read integer
extern printf ; import printf for print
global main
main:
push rbp ;create stack frame
mov rbp , rsp
;scanf a like scanf("%d",a)
lea rdi , [format] ; first parameter
lea rsi , [a] ; second parameter
xor eax,eax ; clear eax
call scanf
;scanf b like scanf("%d",b)
lea rdi, [format] ; first parameter
lea rsi ,[b] ; second parameter
xor eax,eax ; clear eax
call scanf 
;sum
mov eax,[a]
add eax,[b]
;printf
lea rdi,[output];first parameter
movsx rsi , eax ; convert eax(32bit) to rsi(64bit) second parameter
xor eax,eax
call printf
EndProcess: ; end of stack frame
mov rsp , rbp 
pop rbp
xor eax,eax
ret



