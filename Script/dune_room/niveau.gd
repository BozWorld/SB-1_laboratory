extends Node2D

func recommencer():
	$Paul.position = Vector2(225, 225)
	$Paul/Collecte.epices = 0.0
	$Paul.paques()
	
	%Mort.hide()
	
	for ver in $SpawnerVer.get_children() :
		ver.queue_free()
	
	$RandomTickGenerator.start()
	
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("restart"):
		if !$Paul.visible :
			recommencer()
