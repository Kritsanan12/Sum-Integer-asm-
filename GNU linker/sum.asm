section .data ; Declear initilized data 
prompt db 'Enter Your value : ', 0 ; variable string for print 
msgLength equ $ - prompt  ; variable for length of prompt
ResultPrompt db 'Result : ', 0 ;variable string for print
P2Length equ $ - ResultPrompt ; variable for length of ResultPrompt
section .bss ; Declear uninitilazed data (can chnage before) 
result resb 10 ; Reserve 10 byty like result[10]
inputbuffer resb 10 ; Reserve 10 byte like inputbuffer[10]
section .text ; Text section , Entry Point 
global _start ; Declear _start as the entry point of the program
_start: ;Entry point label
call PrintPrompt ; call PrintPrompt Fucntion
call Input ; call Input Function 
mov esi, inputbuffer ; store inputbuffer to esi 
call atoi ; call atoi for converter ASCII to Integer 
push eax ; store eax to stack
call PrintPrompt ; call PrintPrompt
call Input; call Input Function
mov esi, inputbuffer ; store inputbuffer to esi 
call atoi; call atoi for converter ASCII to Integer
pop ebx ; Remove value from stack to ebx
add eax, ebx ; sum eax , ebx
mov edi, result ; result = edi for result when itoa finish
call itoa ; call itoa for converter Integer to ASCII 
;Print ResultPrompt
mov eax, 4 ; sys_write
mov ebx, 1 ; stdout
mov ecx, ResultPrompt ;Specifying Data Address
mov edx, P2Length ; data size
int 0x80;system call
;Print result
mov eax, 4 ; sys_write
mov ebx, 1 ; stdout
mov ecx, result ; Specifying Data address
mov edx, 10 ; data size
int 0x80 ; system call
EndProcess:
mov eax, 1 ; sys_exit
xor ebx, ebx ; clear ebx 
int 0x80 ; system call
PrintPrompt:; like other print function
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, msgLength
int 0x80
ret
Input: ; read ASCII
mov eax, 3 ; sys_read
mov ebx, 0 ; stdin
mov ecx, inputbuffer; Data Address
mov edx, 10 ; data size
int 0x80 ; system call
ret ; like return in other language
;atoi
;Input : esi
;Output : eax
atoi:
xor eax, eax ; clear eax
atoi_loop:
movzx ecx, byte [esi] ; Used to read the byte value from the memory that the ESI is pointing to.
test ecx, ecx ; TEST if EAX is zero or not
jz atoi_done ; jump to atoi_done if TEST is zero
cmp ecx, 10 ; compare ecx 10 for check if end of string
je atoi_done ; jump to atoi_done if ecx = 10 
sub ecx, '0' ; convert ASCII to Integer
imul eax, eax, 10 ; Multiply the value in EAX by 10 to shift the digit to the left.
add eax, ecx ; store ecx to eax
inc esi ; move to the next character in a string like esi++
jmp atoi_loop ; jump atoi_loop for loop
atoi_done: 
ret ; return
;itoa
;input = EAX
;output = EDI
itoa:
push edi ; store edi to stack
mov ecx, 10 ; set ecx to 10 for counter
add edi, 9 ; Mov EDI to the end of the buffer
mov byte [edi], 0 ; Null-Terminate the string
itoa_loop:
dec edi ; mov EDI backward
xor edx, edx ; clear edx (to hold remainder )
div ecx ; Divide EAX by 10, quotient in EAX,remainder in EDX
add dl, '0' ; connvert remainder to ASCII
mov [edi], dl ; store ASCII digit in buffer
test eax, eax ; check if quotient is zero 
jnz itoa_loop ; if not zero repeat loop
pop ecx ; restore ecx (not used)
sub ecx, edi ; calculate the length of the string
ret ; retuen edi
