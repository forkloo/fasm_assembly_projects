format PE Console 4.0
entry start

include 'win32ax.inc'

section '.text' code readable executable

macro srand seed{
      fild [mm]

      fild [aa]
      fild [seed]
      fmulp
      fild [bb]
      faddp

      fprem
      fstp [los]
      ffree st0
}

macro rand{
      fld [l2]
      fld [l1]
      fsubp
      fild [incr]
      faddp

      fld [los]
      fprem
      fld [l1]
      faddp

      fistp word [losowa] ;konwersja do int
      ffree st0 ;wyczyœæ st0
      mov eax, 0
      mov ax, [losowa] ;ustaw jako zwracan¹ wartoœæ
}

macro transform x0, y0, llosowa{
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

      fstp [x0]

      ;get new y
      fld [e]
      fld [y_wart]
      fmulp
      fld [f]
      faddp

      fstp [y0]
}



macro calc_pixel x0, xe, y0, ye{
      ;get xe
      fild [gxmax]
      fld [x0]
      fld [xmin]
      fsubp
      fld [xmax]
      fld [xmin]
      fsubp
      fdivp
      fmulp
      fistp [xe]

      ;get ye
      fild [gymax]
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
      fistp [ye]
}


start:
	int3
	transform x0, y0, losowa
	calc_pixel x0, xe, y0, ye

	srand seedcool
	rand
	transform x0, y0, losowa
	calc_pixel x0, xe, y0, ye


section '.data' data readable writeable
	seedcool dd 434684
	x0 dd 0
	y0 dd 0
	xe dw 0
	ye dw 0


	xmin dd -1.5
	xmax dd 1.5
	ymin dd -1.5
	ymax dd 1.5

	gxmax dw 800
	gymax dw 600
	xxe dd 0
	yye dd 0

	a dd 0.5
	c dd -0.5
	e dd 0.5
	f dd -0.5
	x dd 0.0
	y dd 0.0
	los dd 0
	losowa dw 66

	aa dq 13100233
	bb dq 11040857
	mm dq 9999991
	time dq 1641306165

	l1 dd 0.0
	l2 dd 99.0
	incr dd 1


