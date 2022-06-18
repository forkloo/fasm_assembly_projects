format PE Console 4.0
entry start
include 'macro/import32.inc'
section '.text' code readable executable
start:
	push tekst
	call [printf]
	add esp,4
	call [_getch]
	mov eax,0
	ret
section '.data' data readable writeable
	tekst db 'hello World!',0
section '.idata' import data readable writeable
	library msvcrt, 'MSVCRT.DLL'
	import msvcrt,\
	printf,'printf',\
	_getch,'_getch'