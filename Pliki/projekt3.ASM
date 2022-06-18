format PE Console 4.0

entry start
include 'win32ax.inc'


macro funkcja x
{
	fld [x]
	fsin
	fld [x]
	fdivp st1, st0
	fstp [f]
}

macro dodaj zm1, zm2
{
	fld [zm1]
	fld [zm2]
	faddp
	fstp [zm1]
}

macro pomnoz zm1, zm2
{
	fld [zm1]
	fld [zm2]
	fmul st0, st1
	fstp [zm2]
}

macro obliczSegment
{

	fldz
	fstp [wynikSeg]
	;0
	funkcja a ; -> f
	dodaj wynikSeg, f

	fld [h]
	fld [a]
	faddp
	fstp [a]

	;1
	funkcja a ; -> f

	fld [f]
	fild [mnoznik]
	fmul st0, st1
	ffree st1
	fstp [f]

	dodaj wynikSeg, f
	fld [a]
	fld [h]
	faddp
	fstp [a]

	;2
	funkcja a ; -> f
	dodaj wynikSeg, f

	;int3
	ffree st0

	fld [h]
	fild [dzielnik3]
	fdivp st1,st0
	fstp [f]
	pomnoz wynikSeg,f
	dodaj wynik, wynikSeg
	ffree st0
}

;sin(x)/x
section '.text' code readable writeable
start:
	cinvoke printf, <"Podaj a",13, 10>
	cinvoke scanf, <"%lf">, a
	cinvoke printf, <"Podaj b",13, 10>
	cinvoke scanf, <"%lf">, b
	cinvoke printf, <"Podaj n przedzialow",13, 10>
	cinvoke scanf, <"%d">, n


obliczH:
	fld [b]
	fld [a]
	fsubp st1, st0
	fild [n]

	fdivp st1, st0
	fild [dzielnik]
	fdivp st1, st0
	fstp [h]

petla:
	obliczSegment

	fld [a]
	fcomp [b]
	fstsw ax
	sahf
	jb petla
	cinvoke printf, <"wynik: %llf",13, 10>, dword [wynik], dword [wynik+4], dword [wynik+8]



koniec:
	cinvoke getch
	invoke ExitProcess

section '.data' data readable writeable
	wynik dq 0.0
	wynikSeg dq 0.0
	a dq 0.0
	b dq 0.0
	n dw 0

	h dq 0.0
	f dq 0.0

	dzielnik dq 2
	dzielnik3 dq 3
	mnoznik dq 4


section '.idata' import data readable writeable
	library msvcrt, 'MSVCRT.DLL', kernel32, 'kernel32.dll'

	import msvcrt,\
	printf,'printf',\
	getch, '_getch',\
	scanf, 'scanf'

	import kernel32,\
	ExitProcess, 'ExitProcess'