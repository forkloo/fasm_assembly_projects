format PE Console 4.0
entry start
include 'win32a.inc'
include 'win_macros.inc'


section '.data' data readable writeable
	posKursorDane dw 2
	mnoznikOctShr db 3
	mnoznikHexShr db 4
	binTekst db "[bin] = ", NULL
	octTekst db "[oct] = ", NULL
	decTekst db "[dec] = ", NULL
	hexTekst db "[hex] = ", NULL
	koniecTekst db "Wcisnij dowolny klawisz aby zakonczyc program...", NULL

section '.text' code readable executable

start:
	xor ebx, ebx
	xor ecx, ecx
	mov cl, 16

wpisywanie:
       ; int3
	pob_znak

	cmp al, 0x08
	je backspace
	cmp al, 0x0D
	je przygotuj
	cmp cl, 0
	jnz wpisz_bit

	jmp wpisywanie


przygotuj:
	push cx ;ilosc zer z lewej strony
	push bx ;kopia zapasowa bx

wyswietl_bin:
	ustaw_kursor 1, 0
	wyswietl binTekst

	mov cl, 16d

wb_sprawdz_znak:
	rcl bx, 1
	jc wb_ustaw1
	mov al, '0'	;ustaw 0 do wypisania
	jmp wb_wypisz_znak

wb_ustaw1:
	mov al, '1'

wb_wypisz_znak:
	wysw_znak al
	loop wb_sprawdz_znak
	pop bx

wyswietl_oct:
	ustaw_kursor 2, 0
	wyswietl octTekst
	mov cl, 6

wo_przesun:
	push bx ;zapamiêtaj wartoœæ oryginaln¹
	push cx

	mov al, 6
	sub al, cl
	mul [mnoznikOctShr]
	mov cl, al
	xor ax, ax

	;dzielenie bitów w bx na potrójne grupy
	shr bx, cl
	shl bx, 13
	shr bx, 13

	pop cx

	add bl, 30h	;dodaj 30 ¿eby otrzymaæ kod ascii liczby

	pop ax		;wrzuæ oryginaln¹ wartoœæ na ax
	push bx 	;wrzuæ znak na stos

	mov bx, ax    ;wrzuæ oryginaln¹ wartoœæ z ax do bx

	loop wo_przesun
	mov cl, 6

wo_wypisz:
	pop ax
	wysw_znak al
	loop wo_wypisz
	;na górze stosu jest liczba zer po lewej stronie
	;bx - wartoœæ oryginalna

wyswietl_dec:
	ustaw_kursor 3,0
	wyswietl decTekst
	;ustaw_kursor 3, [posKursorDane]

	pop cx	;wrzuæ iloœæ zer z lewej do cx
	inc cx	;zwiêksz o 1 ¿eby najstarszy bit znalaz³ siê w fladze carry
	;liczba zer z lewej strony ju¿ nie jest potrzebna, nie zapisuj jej
	push bx ;zapisz oryginaln¹ wartoœæ
	mov ax,bx
	shl ax,cl ;przesuñ bity tak, ¿eby najstarszy bit trafi³ co carry
	jnc wd_jestDodatnia
	wysw_znak '-' ;je¿eli flaga carry = 1 to wypisz minus
	jmp wd_przygotuj

wd_jestDodatnia:
	wysw_znak '+'

wd_przygotuj:
	xor dx,dx
	shr ax,cl ;przesuñ bity z powrotem, ale bez najstarszego bitu
	mov cl, 0

wd_oblicz:
	mov bx, 10 ;dzielnik
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

wyswietl_hex:
	ustaw_kursor 4, 0
	wyswietl hexTekst
	;ustaw_kursor 4, [posKursorDane]

	mov cl, 4

wh_przesun:
	push bx ;zapamiêtaj wartoœæ binarn¹ z bx
	push cx

	mov al, 4
	sub al, cl
	mul [mnoznikHexShr]
	mov cl, al
	xor ax, ax

	;dzielenie bitów w bx na potrójne grupy
	shr bx, cl
	shl bx, 12
	shr bx, 12

	pop cx

	cmp bx, 10
	jb wh_liczba
	add bx, 55

	jmp wh_zapiszZnak

wh_liczba:
	add bx, 30h

wh_zapiszZnak:
	pop ax
	push bx
	mov bx, ax
	loop wh_przesun
	mov cl, 4

wh_wypisz:
	pop ax

	wysw_znak al

	loop wh_wypisz
	jmp koniec



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
	cmp cl, 16
	je wpisywanie
	inc cl
	shr bx, 1
	wysw_znak 0x08
	wysw_znak 0x20
	wysw_znak 0x08
	jmp wpisywanie

koniec:
	ustaw_kursor 5,0
	wyswietl koniecTekst
	pob_znak
	end_prog
