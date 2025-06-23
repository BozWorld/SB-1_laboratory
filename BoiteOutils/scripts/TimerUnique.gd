extends Timer
class_name TimerUnique

func _ready() -> void:
	timeout.connect(on_timeout)

func on_timeout():
	queue_free()
