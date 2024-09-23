extends Node

const VITESSE_MAX : float = 6

var velocite : Vector2
var direction : Vector2
@onready var ver : Node2D = get_parent()

signal changement_etat

func _ready():
	direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	velocite = direction * 6
	if velocite :
		velocite = velocite.limit_length(VITESSE_MAX)
		ver.position += velocite
