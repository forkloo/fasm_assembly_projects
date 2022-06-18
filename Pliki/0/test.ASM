format PE Console 4.0

include 'WIN32A.INC'

section '.text' code readable executable

mov ah,0h
int 16h
mov ah,0eh
int 10h


