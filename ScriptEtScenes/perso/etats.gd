extends StateMachine

func _ready() -> void:
	add_state("attend")
	add_state("cours")
	add_state("saute")
	add_state("tombe")
	
	call_deferred("set_state", states.attend)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.attend:
			if not parent.is_on_floor():
				if parent.velocite.y >= 0 :
					return states.saute
				elif parent.velocite.y < 0:
					return states.tombe
			elif parent.velocite.x + parent.velocite.z != 0 :
				return states.cours
		
		states.cours:
			if not parent.is_on_floor():
				if parent.velocite.y >= 0 :
					return states.saute
				elif parent.velocite.y < 0:
					return states.tombe
			elif parent.velocite.x + parent.velocite.z == 0 :
				return states.attend
		
		states.saute:
			if parent.is_on_floor():
				return states.attend
			elif parent.velocite.y < 0:
				return states.tombe
		states.tombe:
			if parent.is_on_floor():
				return states.attend
			elif parent.velocite.y >= 0:
				return states.saute

func _enter_state(new_state, old_state):
	$HBoxContainer/DebugStates._changement_etat(states.find_key(new_state))

func _exit_state(old_state, new_state):
	pass
