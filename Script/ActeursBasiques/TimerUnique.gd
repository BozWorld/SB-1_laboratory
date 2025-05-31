extends Timer
class_name TimerUnique

func _ready() -> void:
	timeout.connect(queue_free)
