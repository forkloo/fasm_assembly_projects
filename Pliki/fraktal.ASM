format PE GUI 4.0

include 'win32ax.inc'

section '.text' code readable executable

int3
stdcall srand, 0
ccall rand
stdcall srand, -1
ccall rand


proc srand stdcall, seed:DWORD
      fild [mm]

      fild [aa]

      cmp [seed], -1
      je new
      jne first
      first:
	fild [seed]
	jmp atend
      new:
	fild [los]
      atend:


      fmulp
      fild [bb]
      faddp

      fprem
      fstp [los]
      ffree st0
      ret
endp

proc rand c
      fld [l2]
      fld [l1]
      fsubp
      fild [incr]
      faddp

      fld [los]
      fprem
      fld [l1]
      faddp

      fistp word [losowa]
      fild [losowa]
      fistp word[los]

      ffree st0 ;wyczyœæ st0
      mov eax, 0
      mov ax, [losowa] ;ustaw jako zwracan¹ wartoœæ
      ret
endp

proc transform stdcall, x0_wsk:DWORD, y0_wsk:DWORD, llosowa:WORD
local x_wart:DWORD
local y_wart:DWORD

      mov ebx, [x0_wsk]
      mov eax, [ebx]
      mov [x_wart], eax;x

      mov ecx, [y0_wsk]
      mov edx, [ecx]
      mov [y_wart], edx;y

      cmp [llosowa], 33d
      jbe first33
      cmp [llosowa], 66d
      jbe second33
      jmp third

      first33:
	fld [baza]
	fstp [a]

	fld [baza]
	fchs
	fstp [c]

	fld [baza]
	fstp [e]

	fld [baza]
	fstp [f]
	jmp exitIf

      second33:
	fld [baza]
	fstp [a]

	fld [baza]
	fchs
	fstp [c]

	fld [baza]
	fstp [e]

	fld [baza]
	fchs
	fstp [f]
	jmp exitIf

      third:
	fld [baza]
	fstp [a]

	fld [baza]
	fstp [c]

	fld [baza]
	fstp [e]

	fld [baza]
	fchs
	fstp [f]

      exitIf:


      ;get new x
      fld [x_wart]
      fld [a]
      fmulp
      fld [c]
      faddp

      fstp DWORD[ebx]

      ;get new y
      fld [e]
      fld [y_wart]
      fmulp
      fld [f]
      faddp

      fstp DWORD[ecx]
      ret
endp



proc calc_pixel stdcall x0:DWORD, xe:DWORD, y0:DWORD, ye:DWORD, gW:DWORD, gH:DWORD
      mov ebx, 0
      mov ecx, 0
      mov ebx, [xe]
      mov ecx, [ye]

      ;get xe
      fild [gW]

      fld [x0]
      fld [xmin]
      fsubp
      fld [xmax]
      fld [xmin]
      fsubp
      fdivp

      fmulp
      fistp [xeInt]
      fild [xeInt]
      fistp DWORD[ebx]

      ;get ye
      fild [gH]
      fild [incr]
      fld [y0]
      fld [ymin]
      fsubp
      fld [ymax]
      fld [ymin]
      fsubp
      fdivp
      fsubp
      fmulp
      fistp [xeInt]
      fild [xeInt]
      fistp DWORD[ecx]

      ret
endp



section '.data' data readable writeable
	xeInt dw 0
	yeInt dw 0

	xmin dd -1.5
	xmax dd 1.5
	ymin dd -1.5
	ymax dd 1.5

	baza dd 0.5
	a dd 0.5
	c dd 0.5
	e dd 0.5
	f dd 0.5
	x dd 0.0
	y dd 0.0
	los dd 0
	losowa dw 0

	aa dq 13100233
	bb dq 11040857
	mm dq 9999991
	time dq 1641306165

	l1 dd 0.0
	l2 dd 99.0
	incr dd 1

	a1 dd 0.0
	b1 dd 0.0
	xe dd 0
	ye dd 0
	gymax dd 600
	gxmax dd 800

section '.edata' export data readable
	export 'sierpinski.DLL',\
	       srand,'srand',\
	       rand,'rand',\
	       transform,'transform',\
	       calc_pixel,'calc_pixel'

section '.reloc' fixups data readable discardable

