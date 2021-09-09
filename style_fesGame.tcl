global style
global game

proc setStyle {} {
    global style
    global game
    
    #ventana
    set style(width) 1015
    set style(height) 690
    set style(l_width) 250
    set style(l_height) 690
    set style(r_width) [expr {$style(width) - $style(l_width)}]
    set style(r_height) 690
    set style(geometry) "$style(width)x$style(height)+0+0"
    
    # colores
    set style(bg_colorL) "#0C253C" 
    set style(bg_colorR) "#D8D8D8" 
    set style(colorLineEnemyBad) "#5D0CE3"
    set style(colorLineEnemyGood) "#08BF0A"

    # imagenes
    set style(logo) "RES/GUITex_REROB.png"
    set style(splat1) "RES/splat1.gif"
    set style(bg) "RES/background.png"
    set style(enemy) "RES/enemy.png"
    set style(enemy2) "RES/enemy2.png"
    set style(enemy3) "RES/enemy3.png"
    set style(enemy4) "RES/enemy4.png"
    set style(gun) "RES/gun.png"
    set style(nave) "RES/nave.png"

    set style(img_logo) [image create photo -file $style(logo) -format png ]
    set style(img_splat1) [image create photo -file $style(splat1) -format gif ]
    set style(img_bg) [image create photo -file $style(bg) -format png ]
    set style(img_enemy) [image create photo -file $style(enemy) -format png]
    set style(img_enemy2) [image create photo -file $style(enemy2) -format png]
    set style(img_enemy3) [image create photo -file $style(enemy3) -format png]
    set style(img_enemy4) [image create photo -file $style(enemy4) -format png]
    set style(img_gun) [image create photo -file $style(gun) -format png]
    set style(img_nave) [image create photo -file $style(nave) -format png]

    #[image width  $style(img_gun)]
    #[$style(img_gun) get 50 20]
    
    
    
    # sonidos

    # textos
    set style(title) "Fes Game - ReabRob 2021"
    set style(txtPoints) "Points: "
    set style(txtStiff) "Stiffnes: "
    set style(txtTime) "Time: "
    set style(txtLog) "LOG: "
    

    # game
    set game(wigle_enemy_d) 10
    set game(wigle_enemy_t) 1000
    set game(deltaX_gun) 10
    set game(deltaT_gun) 32
    set game(pauseGun_t) 1000
    set game(isLoop) 0
    
    set game(x_nave) 50
    set game(y_nave) [expr {$style(r_height) / 2 - 50}]
    set game(x_gun) [expr {$game(x_nave) + [image width $style(img_nave)] - 20}]
    set game(y_gun) [expr {$game(y_nave) + 25}]

    set game(nome) "Player_"
    set game(points) 0
    set game(stiff) 0
    set game(time) 0
    set game(moveGun) 1
    set game(txtPoints) ...
    set game(txtStiff) ...
    set game(txtTime) ...
    set game(txtLog) ...
    set game(gameover) 1
    set game(curTargets) target2

    updateTxtPoints
    updateTxtStiff
    updateTxtTime
    
    list game(targets)   
}

proc setLog {str} {
    global game
    global style
    set game(txtLog)  "$style(txtLog)$str"
}

proc updateTxtPoints {} {
    global game
    global style
    set game(txtPoints) "$style(txtPoints)$game(points)"
}

proc updateTxtTime {} {
    global game
    global style
    set game(txtTime) "$style(txtTime)$game(time)"
}

proc updateTxtStiff {} {
    global game
    global style
    set game(txtStiff) "$style(txtStiff)$game(stiff)"
}

setStyle