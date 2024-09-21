extends Node2D

enum States { IDLE, MOVE, IN_AIR }
var currentState = States.IDLE

var velocite : Vector2
var acceleration : Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
