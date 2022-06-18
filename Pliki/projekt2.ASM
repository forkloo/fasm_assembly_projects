format PE Console 4.0
entry start
include 'win32ax.inc'

macro przesun_w_lewo bajt
{
	rcl [bajt + 0], 1
	rcl [bajt + 1], 1
	rcl [bajt + 2], 1
	rcl [bajt + 3], 1
	rcl [bajt + 4], 1
	rcl [bajt + 5], 1
	rcl [bajt + 6], 1
}

macro przesun_w_prawo bajt
{
	rcr [bajt + 6], 1
	rcr [bajt + 5], 1
	rcr [bajt + 4], 1
	rcr [bajt + 3], 1
	rcr [bajt + 2], 1
	rcr [bajt + 1], 1
	rcr [bajt + 0], 1
}

macro odejmij b1, b2
{
	mov al,[b1 + 0]
	sbb al, [b2 + 0]
	mov [b1+0],al
	
	mov al,[b1 + 1]
	sbb al, [b2 + 1]
	mov [b1+1],al
	
	mov al,[b1 + 2]
	sbb al, [b2 + 2]
	mov [b1+2],al
	
	mov al,[b1 + 3]
	sbb al, [b2 + 3]
	mov [b1+3],al
	
	mov al,[b1 + 4]
	sbb al, [b2 + 4]
	mov [b1+4],al
	
	mov al,[b1 + 5]
	sbb al, [b2 + 5]
	mov [b1+5],al
	
	mov al,[b1 + 6]
	sbb al, [b2 + 6]
	mov [b1+6],al
}

macro przypisz b2, b1
{
	mov al,[b1 + 0]
	mov [b2+0],al
	
	mov al,[b1 + 1]
	mov [b2+1],al
	
	mov al,[b1 + 2]
	mov [b2+2],al
	
	mov al,[b1 + 3]
	mov [b2+3],al
	
	mov al,[b1 + 4]
	mov [b2+4],al
	
	mov al,[b1 + 5]
	mov [b2+5],al
	
	mov al,[b1 + 6]
	mov [b2+6],al
}

section '.text' code readable writeable
start:
	cinvoke printf, <"y = (a + b) mod c",10>
	cinvoke printf, <"Podaj a: ">
	cinvoke scanf, <"%llx">, a
	cinvoke printf, <"Podaj b: ">
	cinvoke scanf, <"%llx">, b
	cinvoke printf, <"Podaj c: ">
	cinvoke scanf, <"%llx">, dzielnik

;dodawanie
dodawanie:

	mov ecx, 4
	mov esi, 0
	clc
dodaj_loop:
	mov al, [a+esi]
	mov dl, [b+esi]
	adc al,dl
	mov [dzielna+esi],al
	inc si
	loop dodaj_loop

;dzielenie, modulo
div_k1:
	cmp [dzielnik+6], 0
	ja przesuniecie
	cmp [dzielnik+5], 0
	ja przesuniecie
	cmp [dzielnik+4], 0
	ja przesuniecie
	cmp [dzielnik+3], 0
	ja przesuniecie
	cmp [dzielnik+2], 0
	ja przesuniecie
	cmp [dzielnik+1], 0
	ja przesuniecie
	cmp [dzielnik], 0
	ja przesuniecie
	cinvoke printf, <"***",10,13>
	jmp zakoncz

przesuniecie: ;krok1
	cmp [dzielnik+6], 80h
	jae nie_zero
	inc [k]
	clc
	przesun_w_lewo dzielnik
	jmp przesuniecie

nie_zero:
	clc
	mov al, [dzielna + 6]
	cmp al, [dzielnik+6]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 5]
	cmp al, [dzielnik+5]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 4]
	cmp al, [dzielnik+4]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 3]
	cmp al, [dzielnik+3]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 2]
	cmp al, [dzielnik+2]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 1]
	cmp al, [dzielnik+1]
	jb mniejsze
	ja wieksze
	mov al, [dzielna + 0]
	cmp al, [dzielnik+0]
	jb mniejsze

wieksze:
	clc
	odejmij dzielna, dzielnik
	stc
	przesun_w_lewo wynik
	jmp ety3
	
mniejsze:
	clc
	przesun_w_lewo wynik
	
ety3:
	cmp [k], 0
	jbe zakoncz
	dec [k]
	przesun_w_prawo dzielnik
	jmp nie_zero


zakoncz:
	cinvoke printf, <10, "(a + b) mod c = %llx"> ,dword [dzielna], dword [dzielna+4], dword [dzielna+8]
	cinvoke getch
	invoke ExitProcess


section '.data' data readable writeable
	a db 0, 0, 0, 0, 0, 0, 0, 0, 0
	b db 0, 0, 0, 0, 0, 0, 0, 0, 0
	dzielnik db 0, 0, 0, 0, 0, 0, 0, 0, 0
	dzielna db 0, 0, 0, 0, 0, 0, 0, 0, 0
	wynik db 0, 0, 0, 0, 0, 0, 0, 0, 0
	k db 0

section '.idata' import data readable writeable
	library msvcrt, 'MSVCRT.DLL', kernel32, 'kernel32.dll'

	import msvcrt,\
	printf,'printf',\
	getch, '_getch',\
	scanf, 'scanf'

	import kernel32,\
	ExitProcess, 'ExitProcess'










