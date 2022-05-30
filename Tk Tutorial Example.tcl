. configure -width 200 -height 400
label .header -text "Tk Tutorial Example"
place .header -x 5 -y 2
scale .slider -from 1 -to 100 -orient horiz
.slider configure -variable SlidVal
place .slider -x 5 -y 20
entry .slidbox -width 5 -textvariable SlidVal
place .slidbox -x 120 -y 40
radiobutton .one -text "Mode 1" -variable Mode -value 1
radiobutton .two -text "Mode 2" -variable Mode -value 0
place .one -x 5 -y 70
place .two -x 5 -y 90
text .twindow -width 22 -height 14 -font {clean -14}
place .twindow -x 5 -y 120
button .ok -command {process_data $SlidVal} -text "OK"
place .ok -x 15 -y 350
button .go -command {puts stdout "Go"} -text "GO"
place .go -x 120 -y 350
proc process_data {SlidVal} {puts stdout $SlidVal}
