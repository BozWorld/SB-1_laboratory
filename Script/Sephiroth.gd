extends all_ennemies

func _ready() -> void:
	super._ready()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_ia"):
		pass
