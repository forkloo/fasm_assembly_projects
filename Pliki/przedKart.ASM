format PE Console 4.0

entry start

include 'win32a.inc'
include 'win_macros.inc'


section '.text' code readable writeable

start:
	mov cl, 0
	clrscr
	ustaw_kursor 10,2

	pob_znak
	sub al, 48h
	mov esi, eax
	wysw_znak [text1+esi]

	pob_znak
	end_prog




section '.data' data readable writeable
	text1	db 13,10,"liczba liter: "

