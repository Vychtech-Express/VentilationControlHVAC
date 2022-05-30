. configure  -background #ff80ff
labelframe .2 -foreground #870c78 -relief raised -text TestString
pack .2
label .label1 -text TestLabet
pack .label1
listbox .3
pack .3
entry .entryName1
pack .entryName1
entry .entryName2
pack .entryName2
entry .entryName3
pack .entryName3
set Button1 [button .1 -text ReadSourceData]
pack .1
set TextField [label .4 -font {System 10 {bold roman}} -text TestTextLine]
pack .4
set Button2 [button .d22 -text LoadSourceData]
pack .d22
set Button3 [button .5 -text SaveSourceDataToBD]
pack .5

