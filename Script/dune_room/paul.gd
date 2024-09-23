extends Node2D

enum States { IDLE, MOVE, IN_AIR }
var currentState = States.IDLE

var velocite : Vector2
var acceleration : Vector2

@onready var anim_sprite = $sprite

signal etat_change


func _set_state(etat):
	if not currentState == etat :
		currentState = etat
		etat_change.emit(etat)
