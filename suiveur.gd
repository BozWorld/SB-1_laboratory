extends Node2D

@export var cible : Node2D

@export var vitesse_rattrapage := 0.3

func _physics_process(delta: float) -> void:
	if position != cible.position :
		position = position.lerp(cible.position, vitesse_rattrapage * delta)
