extends Timer

signal random_tick
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_emit_random_tick)


func _emit_random_tick():
	var valeur = randf_range(0,1)
	random_tick.emit(valeur)
