. configure  -background #ff80ff
labelframe .2 -foreground #870c78 -relief raised -text WorkView
pack .2
label .2.label1 -text WorkSpace
pack .2.label1
set VarList01 [listbox .2.3]
pack .2.3
set VarEntry01 [entry .2.entryName1]
pack .2.entryName1
set VarEntry02 [entry .2.entryName2]
pack .2.entryName2
set VarEntry03 [entry .2.entryName3]
pack .2.entryName3
set Button1 [button .1 -background #808040 -text SaveSettings]
pack .1
set TextField [label .4 -font {System 10 {bold roman}} -text Start-Stop]
pack .4
set Button2 [button .d22 -background #00ff00 -text Start]
pack .d22
set Button3 [button .5 -background #ff8040 -text Stop]
pack .5
labelframe .gp12 -relief raised -text Settings -background #ffff00
pack .gp12
set Button01 [button .gp12.b01 -background #80ffff -text UpLoadSettings]
pack .gp12.b01
set VarC01 [checkbutton .gp12.c01 -text Channel1]
pack .gp12.c01
set VarC02 [checkbutton .gp12.c02 -text Channel2]
pack .gp12.c02
set VarC03 [checkbutton .gp12.c03 -text Channel3]
pack .gp12.c03
set VarScaleS00 [scale .gp12.s00 -label Temperature -orient horizontal]
pack .gp12.s00
labelframe .gp12.gp11 -relief raised -text Modes
pack .gp12.gp11
set VarR01 [radiobutton .gp12.gp11.r01 -text Mode1]
pack .gp12.gp11.r01
proc proc01 {  } {
	set a 2
	put a
	
}
set VarR02 [radiobutton .gp12.gp11.r02 -text Mode2]
pack .gp12.gp11.r02
proc proc02 {  } {
	set b 5
}
set VarR03 [radiobutton .gp12.gp11.r03 -text Mode3]
pack .gp12.gp11.r03
proc proc03 {  } {
	set c 12
}

