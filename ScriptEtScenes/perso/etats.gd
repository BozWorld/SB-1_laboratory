extends StateMachine


func _ready() -> void:
	add_state("attend")
	add_state("marche")
	add_state("cours")
	add_state("sprint")
	add_state("tombe")
	add_state("saute")
	add_state("prepare_saut")
	
	call_deferred("set_state", states.attend)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.attend:
			if not parent.is_on_floor():
				if parent.velocite.y >= 0.0 :
					return states.saute
				elif parent.velocite.y < 0.0:
					return states.tombe
			elif parent.saut.genoux_flechis :
				return states.prepare_saut
			elif parent.velocite.x + parent.velocite.z < 0.0 :
				var h_velocity
				h_velocity = parent.velocite
				h_velocity.y = 0.0
				h_velocity = h_velocity.length()
				if h_velocity < 1.5:
					return states.marche
				elif h_velocity < 5.0 :
					return states.cours
				elif h_velocity >= 5.0 :
					return states.sprint
		
		states.marche :
			if not parent.is_on_floor():
				if parent.velocite.y >= 0.0 :
					return states.saute
				elif parent.velocite.y < 0.0:
					return states.tombe
			elif parent.saut.genoux_flechis :
				return states.prepare_saut
			elif parent.velocite.x + parent.velocite.z == 0.0 :
				return states.attend
			elif parent.velocite.x + parent.velocite.z < 0.0 :
				var h_velocity
				h_velocity = parent.velocite
				h_velocity.y = 0.0
				h_velocity = h_velocity.length()
				if h_velocity < 5.0 :
					return states.cours
				elif h_velocity >= 5.0 :
					return states.sprint
		
		states.cours:
			if not parent.is_on_floor():
				if parent.velocite.y >= 0.0 :
					return states.saute
				elif parent.velocite.y < 0.0:
					return states.tombe
			elif parent.saut.genoux_flechis :
				return states.prepare_saut
			elif parent.velocite.x + parent.velocite.z == 0.0 :
				return states.attend
			elif parent.velocite.x + parent.velocite.z < 0.0 :
				var h_velocity
				h_velocity = parent.velocite
				h_velocity.y = 0.0
				h_velocity = h_velocity.length()
				if h_velocity < 1.5 :
					return states.marche
				elif h_velocity >= 5.0 :
					return states.sprint
		
		states.sprint:
			if not parent.is_on_floor():
				if parent.velocite.y >= 0.0 :
					return states.saute
				elif parent.velocite.y < 0.0:
					return states.tombe
			elif parent.saut.genoux_flechis :
				return states.prepare_saut
			elif parent.velocite.x + parent.velocite.z == 0.0 :
				return states.attend
			elif parent.velocite.x + parent.velocite.z < 0.0 :
				var h_velocity
				h_velocity = parent.velocite
				h_velocity.y = 0.0
				h_velocity = h_velocity.length()
				if h_velocity < 1.5 :
					return states.marche
				elif h_velocity < 5.0 :
					return states.cours
		
		states.prepare_saut:
			if !parent.is_on_floor():
				if parent.velocite.y >= 0.0:
					return states.saute
				else :
					return states.tombe
		
		states.saute:
			if parent.is_on_floor():
				return states.attend
			elif parent.velocite.y < 0.0:
				return states.tombe
		states.tombe:
			if parent.is_on_floor():
				return states.attend
			elif parent.velocite.y >= 0.0:
				return states.saute

func _enter_state(new_state, old_state):
	$HBoxContainer/DebugStates._changement_etat(states.find_key(new_state))

func _exit_state(old_state, new_state):
	pass
