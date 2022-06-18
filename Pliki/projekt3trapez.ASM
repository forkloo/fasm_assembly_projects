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

macro przesunXp
{
	fld [xp]
	fld [xprzes]
	faddp
	fstp [xp]
}

macro obliczSegment
{
	funkcja xp ; -> f
	fld [f]
	przesunXp
	funkcja xp
	fld [f]
	faddp
	fld [dzielnik]
	fmulp st1, st0

	fld [wynik]
	faddp
	fstp [wynik]
}

section '.text' code readable writeable
start:
	cinvoke printf, <"Podaj a",13, 10>
	cinvoke scanf, <"%lf">, xp
	cinvoke printf, <"Podaj b",13, 10>
	cinvoke scanf, <"%lf">, xk
	cinvoke printf, <"Podaj n segmentow",13, 10>
	cinvoke scanf, <"%d">, n

obliczPrzesuniecie:
	fld [xk]
	fld [xp]
	fsubp st1, st0
	fild [n]
	fdivp st1, st0
	fstp [xprzes]

petla:
	obliczSegment

	fld [xp]
	fcomp [xk]
	fstsw ax
	sahf
	jb petla

	fld [wynik]
	fld [xprzes]
	fmulp
	fstp [wynik]

	cinvoke printf, <"wynik: %llf",13, 10>, dword [wynik], dword [wynik+4]

koniec:
	cinvoke getch
	invoke ExitProcess

section '.data' data readable writeable
	f dq 0.0
	wynik dq 0.0
	xprzes dq 0.0
	xp dq 0.0
	xk dq 0.0
	n dw 0
	dzielnik dq 0.5

section '.idata' import data readable writeable
	library msvcrt, 'MSVCRT.DLL', kernel32, 'kernel32.dll'

	import msvcrt,\
	printf,'printf',\
	getch, '_getch',\
	scanf, 'scanf'

	import kernel32,\
	ExitProcess, 'ExitProcess'