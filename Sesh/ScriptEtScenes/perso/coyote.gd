extends Attribut3D

var duree = 0.15

var sol_tangible = false
var coyoting = false


func checkSol():
	if parent.is_on_floor() :
		sol_tangible = true
		coyoting = false
		return true
	else :
		if !coyoting and sol_tangible :
			var timer_coyote = TimerUnique.new()
			timer_coyote.wait_time = duree
			timer_coyote.timeout.connect(retourTimer)
			add_child(timer_coyote)
			timer_coyote.start()
			coyoting = true
			sol_tangible = false
			return true
		elif coyoting :
			return true
		
		
		return false
	
	

func retourTimer():
	coyoting = false
