

wm title . "Test fesGame"
wm geometry . "600x400"
wm resizable . 0 0
bind . <Escape> exit

global ob
set ob(crobhome) $::env(CROB_HOME)

proc test_smh_python {} {
    wm title . "Test fesGame"
    
    source $::env(CROB_HOME)/shm.tcl    
    

    wshm pm_npoints 10.0
    after 100 {puts [rshm pm_npoints]}
    
    

}

test_smh_python