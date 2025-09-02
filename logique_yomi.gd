extends Node

@onready var gest_persos = %GestPersos

var stop := tr

func _physics_process(delta: float) -> void:
	if !gest_persos.checkPersos() :
		gest_persos.logiquePersos()
	
