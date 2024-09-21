extends Node

const VITESSE_MAX : float = 8

var velocite : Vector2
var impulsion : Vector2

func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_pressed("bougeBas") or Input.is_action_pressed("bougeHaut"):
		impulsion.y = Input.get_action_strength("bougeBas") - Input.get_action_strength("bougeHaut")
		
	#if Input.is_action_pressed("bougeDroite") or Input.is_action_pressed("bougeGauche"):
		impulsion.x = Input.get_action_strength("bougeDroite") - Input.get_action_strength("bougeGauche")

func _physics_process(delta: float) -> void:
	var acceleration = impulsion * 0.5
	velocite += acceleration
	
	
	if velocite :
		
		if impulsion == Vector2(0,0):
			velocite -= 0.05 * velocite
			if velocite.length() < 1 :
				velocite = Vector2(0,0)
		
		velocite = velocite.limit_length(VITESSE_MAX)
		
		get_parent().position += velocite
	
