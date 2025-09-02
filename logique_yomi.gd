extends Node

@onready var gest_persos = %GestPersos

var stop := true

func _physics_process(delta: float) -> void:
	#print(gest_persos.checkPersos()["persos"])
	if !gest_persos.checkPersos()["pause"] :
		stop = false
		if %UiAction.visible :
			%UiAction.hide()
		
		gest_persos.logiquePersos()
	else :
		stop = true
		gest_persos.checkPersos()
		var persos_prets = gest_persos.checkPersos()["persos"]
		if persos_prets[0].tour != true :
			persos_prets[0].tour = true
			%GestPlans.mettrePlan(persos_prets[0].plan)
		
		if !%UiAction.visible :
			%UiAction.show()
	
