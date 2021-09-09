#! /usr/bin/wish

package require Tk	
package require Ttk	

source style_fesGame.tcl
source guiUtils_fesGame.tcl

global mob
global game


set t_index 0


proc gui_fesGame {} {

    global style

    wm title . $style(title)
	wm geometry . $style(geometry)
	wm resizable . 0 0
    
    # Esta variable identificará la GUI y sus subvariables
    variable mob
    variable game

    frame .lFrame -bg $style(bg_colorL) -w $style(l_width) 
    pack  .lFrame -fill y  -side left
    
    frame .rFrame -bg $style(bg_colorR) -bd 0 -relief solid
    pack  .rFrame -fill both -expand true -side right

    scale .posNave -from 0 -to $style(l_height)  -length 10 -variable game(y_nave) 
    pack .posNave -in .rFrame -fill y -expand true -side left
    

    pack [separator .s3] -fill x -in .lFrame -pady 10

    pack [label .l1 -text "Player name :" -bg $style(bg_colorL) -fg white] -in .lFrame -anchor w -padx 10
    pack [entry .nome -textvariable game(nome) -bg $style(bg_colorL) -fg white ] -in .lFrame -anchor w -padx 10 -fill x

    pack [button .b1 -text "PLAY" -bg $style(bg_colorL) -fg white -command startGame] -in .lFrame -anchor center -pady 10

    pack [separator .s1] -fill x -in .lFrame -pady 10

    pack [label .l3 -textvariable game(txtStiff) -bg $style(bg_colorL) -fg white] -in .lFrame -anchor w -padx 10
    pack [label .lTime -textvariable game(txtTime) -bg $style(bg_colorL) -fg white] -in .lFrame -anchor w -padx 10

    pack [separator .s4] -fill x -in .lFrame -pady 10

    pack [label .lPoints -textvariable game(txtPoints) -bg $style(bg_colorL) -fg white] -in .lFrame 
    

    pack [separator .s2] -fill x -in .lFrame -pady 10

    pack [label .log -textvariable game(txtLog) -bg $style(bg_colorL) -fg white -wraplength 200] -in .lFrame -anchor w -padx 10
    setLog "Bienvenido"

    pack [separator .s5] -fill x -in .lFrame -pady 10

    pack [label .l2 -text "RehaRob 2021" -bg $style(bg_colorL) -fg white] -in .lFrame -side bottom
    set img1 [image create photo -file $style(logo)]
    label .logo  -image $img1 -bg $style(bg_colorL)
    pack .logo -in .lFrame  -padx 50  -side bottom
            
    
    # Eventos de la GUI
    bind . <Escape> exit_fesGame
    bind . <q> updateVars
    
}





proc exit_fesGame {} {
	exit 
}



proc run_fesGame {} {
    global style
    global game

    destroy .c
    set game(targets)  {} 

    canvas .c -bg $style(bg_colorR) -width $style(r_width) -highlightthickness 0
    pack .c -in .rFrame -fill both -expand 1


    .c create image 0 0 -image $style(img_bg) -tag bg -anchor nw
    

    .c create line 0 0 $style(r_width) 0 -width 10 -tag lineEnemy -fill $style(colorLineEnemyBad)
    
    for {set X 0} { $X < 3 } { incr X } {
        for {set Y 0} { $Y < 5 } { incr Y } {
            set xcoord [expr {$style(r_width)/7 * (($X+4)) }]
            set ycoord [expr {$style(r_height)/7 * ($Y+1) }]
            set tagEnemy target$X|$Y
            set tagEnemyX target$Y
            .c create image $xcoord $ycoord -image $style(img_enemy) -tags [list target $tagEnemy $tagEnemyX] -anchor nw
            lappend game(targets) [list $tagEnemy $xcoord $ycoord $tagEnemyX]  
            if {$game(curTargets) == $tagEnemyX} {
                .c moveto lineEnemy 0 [expr {$ycoord + 43}]
            }
       }
    }
    .c itemconfigure target -image $style(img_enemy)
    .c itemconfigure $game(curTargets) -image $style(img_enemy2)
    
     

    

    proc wigleEnemy {} {
        global game
        .c move target $game(wigle_enemy_d) 0
        update
        set game(wigle_enemy_d) [expr {$game(wigle_enemy_d) * (-1)}]
        
        if {$game(isLoop) == 0} {
            return
        }
        if {$game(gameover) == 0} {
            after $game(wigle_enemy_t) wigleEnemy
        }
     
    };wigleEnemy


    .c create image $game(x_nave) $game(y_nave) -image $style(img_nave) -tag user -anchor nw
    


    .c create image 0 100 -image $style(img_gun) -tag gun
    
    
    #.c create text 40 40 -text "Points : 0" -anchor nw -fill red -font [list null 20]
    

}

proc SetImg {obj img} {
    $obj configure -image $img
}

proc MoveImg {obj dX dY} {
    place $obj -x $dX -y $dY
}    

proc runTime {} {
    global game

    if {$game(isLoop) == 0} {
        return
    }
    incr game(time)
    updateTxtTime
    if {$game(gameover) == 0} {
        after 100 runTime
    }
}

proc pauseGun {} {
    global game
    set game(moveGun) 0
    after 2000 {set game(moveGun) 1}
    vwait game(moveGun)
}


proc loopGame {} {
    global game
    global style    


    set collided 0

    if {$game(moveGun) == 1} {
        set game(x_gun) [expr {$game(x_gun) + $game(deltaX_gun)}]
    }
    

    foreach var $game(targets) {
        
        if { [expr {$game(x_gun) + 60}] > [lindex $var 1] && [expr {$game(x_gun) + 60}] < [expr {[lindex $var 1] + 100 }] && 
                [expr {$game(y_gun) + 20}] > [lindex $var 2] && [expr {$game(y_gun) + 20}] < [expr {[lindex $var 2] + 100 }] } {
                

                set idx [lsearch $game(targets) $var]

                set game(targets) [lreplace $game(targets) $idx $idx]
                destroyEnemy [lindex $var 0]
                #.c delete [lindex $var 0]
                set collided 1

                
                if {$game(curTargets) == [lindex $var 3]} {
                    incr game(points) 4
                    set curTargets [lindex $game(targets) [expr { int(rand()*[llength $game(targets)])  }]]
                    set game(curTargets) [lindex $curTargets 3]
                    .c itemconfigure target -image $style(img_enemy)
                    .c itemconfigure $game(curTargets) -image $style(img_enemy2)
                    .c moveto lineEnemy 0 [expr {[lindex $curTargets 2] + 43}]
                    
                }
                
                incr game(points)
                updateTxtPoints
                break
        }
    }    

    

    if {$game(x_gun) > $style(r_width) || $collided || $game(moveGun) == 0} {
        set game(x_gun) [expr {$game(x_nave) + 40}]
        set game(y_gun) [expr {$game(y_nave) + 25}]
    } 

    # set $game(y_nave) con la lectura del AnkleBot
    
    .c moveto user $game(x_nave) $game(y_nave) 
    .c moveto gun $game(x_gun) $game(y_gun) 
    update

    if {$game(isLoop) == 0} {
        return
    }

    if {$game(gameover) == 0} {
        after $game(deltaT_gun) loopGame
    }
    
};

proc delay1 {TT} {
    global game
    set game(timeOutDeleteEnemy) 0
    after $TT {set game(timeOutDeleteEnemy) 1}
    vwait game(timeOutDeleteEnemy)
    update
}

proc destroyEnemy {tagEnemy} {

    global style
    global game
    set game(moveGun) 0
    set game(delete) $tagEnemy
    set TT 200

    after [expr {$TT * 1}] {
        global game
        .c itemconfigure $game(delete) -image $style(img_enemy3)
    }

    after [expr {$TT * 2}] {
        global game
        .c itemconfigure $game(delete) -image $style(img_enemy4)
    }

    after [expr {$TT * 3}] {
        global game
        .c itemconfigure $game(delete) -image $style(img_enemy3)
    }

    after [expr {$TT * 4}] {
        global game
        .c itemconfigure $game(delete) -image $style(img_enemy4)
    }


    after $game(pauseGun_t) {
        global game
        set game(moveGun) 1
        .c delete $game(delete)
    }
        
        
    
     

  
   
}

proc preStartGame {} {
    global game

    set game(gameover) 0
    run_fesGame
    runTime
    after 0 pauseGun
    loopGame
}

proc startGame {} {
    

    stopGame
    

    #Enable AnkleBot
    #Move Anklebot to 0

    preStartGame

}

proc stopGame {} {
    global game
    set game(gameover) 1
    
    set game(time) 0
    updateTxtTime

    set ::resume 0
    after 2000 {set ::resume 1}
    vwait ::resume

    #Move Anklebot to 0
    #Disable AnkleBot
}


gui_fesGame

set game(isLoop) 0
preStartGame
set game(isLoop) 1

