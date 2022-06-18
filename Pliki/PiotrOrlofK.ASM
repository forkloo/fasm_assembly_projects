format PE Console 4.0

entry start

include 'win32a.inc'
include 'win_macros.inc'


section '.text' code readable writeable

start:
	mov ax, 0
	mov bx, 0
	mov esi, 0
	clrscr
	ustaw_kursor 10,2

	wyswietl text1

	ustaw_kursor 14,10

petla:
       mov al, [text1+esi]
       ;int3
       cmp al, NULL
       je zakoncz

       cmp al, 48d
       jae jest_liczba
       jb inc_iterator

jest_liczba:
	cmp al, 57d
	ja inc_iterator

	sub al, 48d
	cmp al, bl
	ja nowy_max
	jmp inc_iterator

nowy_max:
	mov bl, al

inc_iterator:
	inc esi
	jmp petla




zakoncz: ;punkt 9
	wyswietl text_end
	add bx, 48d
	wysw_znak bl
	pob_znak
	end_prog




section '.data' data readable writeable
	text_end db "Najwieksza liczba to: ",NULL
	text1	db "z3mie48i3aZm21na"

