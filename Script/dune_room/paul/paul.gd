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


func _on_collision_area_entered(area: Area2D) -> void:
	if area is CollisionVer :
		mort()

func mort():
	hide()
	$deplacements.libre = false
	process_mode = Node.PROCESS_MODE_DISABLED
	%Mort.show()

func paques():
	show()
	$deplacements.libre = true
	process_mode = Node.PROCESS_MODE_INHERIT
