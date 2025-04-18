Hello My name is Kritsanan , This is My first Program of Assembly
 
 # how to compile with gnu linker
 ```
 nasm -f elf -g -F dwarf sum.asm
```
```
 ld -m elf_i386 sum.o -o sum
```
 # how to compile with gcc linker
 ```
 nasm -f elf64 -g -F dwarf sum.asm
 ```
```
gcc -no-pie -g -o sum-gcc sum-gcc.o 
 ```
