extends AnimatedSprite2D

@onready var perso = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	perso.etat_change.connect(_changement_anim)

func _changement_anim(state):
	match perso.currentState :
		perso.States.IDLE :
			play("idle")
		perso.States.MOVE :
			play("move")
