extends Node2D
class_name Ver

var duree_intouchable := 1.312

func _ready() -> void:
	var timer_intouchable = TimerUnique.new()
	timer_intouchable.wait_time = duree_intouchable
	add_child(timer_intouchable)
	timer_intouchable.start()
	await timer_intouchable.timeout
	$sprite.intouchable = false
