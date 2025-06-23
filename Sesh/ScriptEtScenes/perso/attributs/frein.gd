extends Attribut3D

const VITESSE : float = 8.0

var mouvement : Vector2

var freine = false

func get_input():
	var impulse = Vector3(0,0,0)
	if (
		!Input.is_action_pressed("bougerAVANT") && 
		parent.machine_etats.get_state() == parent.machine_etats.states.cours
		):
		freine = true
	
	else :
		freine = false
	

func _deplacement_process(delta):
	get_input()
	
	if freine :
		if parent.velocite.length() > 0.8 :
			parent.appliquer_force(-parent.velocite * 7.5 * delta *(1.0/(parent.velocite.length() + 0.2)))
		else :
			parent.velocite = Vector3(0,0,0)
	
	
