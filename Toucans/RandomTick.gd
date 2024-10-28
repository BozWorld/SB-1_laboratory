extends Timer

signal random_tick
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(gen_random_tick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func gen_random_tick():
	var value = randi_range(0,100)
	random_tick.emit(value)
