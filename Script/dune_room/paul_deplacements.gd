extends Node

const VITESSE_MAX : float = 8

var velocite : Vector2
var impulsion : Vector2
@onready var perso : Node2D = get_parent()

signal changement_etat

func _ready():
	changement_etat.connect(perso._set_state)

func _unhandled_input(event: InputEvent) -> void:
	impulsion.y = Input.get_action_strength("bougeBas") - Input.get_action_strength("bougeHaut")
	impulsion.x = Input.get_action_strength("bougeDroite") - Input.get_action_strength("bougeGauche")

func _physics_process(delta: float) -> void:
	var acceleration = impulsion 
	velocite = velocite*0.5 + acceleration * 2
	
	if velocite :
		changement_etat.emit(perso.States.MOVE)
		if impulsion == Vector2(0,0):
			velocite -= 0.2 * velocite
			if velocite.length() < 1 :
				velocite = Vector2(0,0)
		
		velocite = velocite.limit_length(VITESSE_MAX)
		perso.position += velocite
	else :
		changement_etat.emit(perso.States.IDLE)
