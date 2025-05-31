extends Node

const VITESSE_MAX : float = 6

@export var puissance_acceleration := 1.0

var velocite : Vector2
var direction : Vector2
@onready var ver : Node2D = get_parent()

signal changement_etat

func _ready():
	direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	direction = direction.normalized()

func _physics_process(delta: float) -> void:
	velocite += direction * puissance_acceleration * delta
	if velocite :
		velocite = velocite.limit_length(VITESSE_MAX)
		ver.position += velocite
	
	if abs(ver.position.x) > 225.0 :
		if ver.position.x/abs(ver.position.x) > 0 and direction.x > 0 :
			velocite.x =- velocite.x * 0.8
			direction.x =- direction.x
		if ver.position.x/abs(ver.position.x) < 0 and direction.x < 0 :
			velocite.x =- velocite.x * 0.8
			direction.x =- direction.x
	if abs(ver.position.y) > 225.0 :
		if ver.position.y/abs(ver.position.y) > 0 and direction.y > 0 :
			velocite.y =- velocite.y * 0.8
			direction.y =- direction.y
		if ver.position.y/abs(ver.position.y) < 0 and direction.y < 0 :
			velocite.y =- velocite.y * 0.8
			direction.y =- direction.y
	
