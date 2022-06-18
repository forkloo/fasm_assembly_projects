format PE Console 4.0
entry start
include 'win32a.inc'
include 'win_macros.inc'

posKursorDane dw 2
mnoznikOctShr db 3
baseDec db 1

section '.text' code readable executable

start:
	xor ebx, ebx
	xor ecx, ecx
	mov cl, 16

wpisywanie:
	;int3
	pob_znak
	cmp cl, 0
	jnz wpisz_bit
	cmp al, 0x08
	je backspace
	cmp al, 0x0D
	je wyswietl_dec

	jmp wpisywanie


wyswietl_dec:
	;int3
	ustaw_kursor 2,0
	wysw_znak 'D'
	ustaw_kursor 2, [posKursorDane]

	push bx
	mov ax,bx
	shl ax,1
	jnc wd_przygotuj

wstaw_minus:
	wysw_znak '-'

wd_przygotuj:
	mov cl, 0
	xor dx,dx
	shr ax,1

wd_oblicz:
	mov bx, 10
	div bx
	add dx, 30h

	push dx
	xor dx,dx

	inc cl

	cmp ax, 0
	ja wd_oblicz


	jmp wd_wypisz

wd_wypisz:
	pop ax
	wysw_znak al

	loop wd_wypisz
	pop bx
	ret


wpisz_bit:
	cmp al, '0'
	je wpisz0
	cmp al, '1'
	je wpisz1
	cmp al, 0x08
	je backspace

	jmp wpisywanie


wpisz0:
	dec cl
	shl bx, 1
	wysw_znak al
	jmp wpisywanie

wpisz1:
	dec cl
	shl bx, 1
	add bx, 1
	wysw_znak al
	jmp wpisywanie

backspace:
	inc cl
	shr bx, 1
	wysw_znak 0x08
	wysw_znak 0x20
	wysw_znak 0x08
	jmp wpisywanie

koniec:
	mov eax, eax
	ret


