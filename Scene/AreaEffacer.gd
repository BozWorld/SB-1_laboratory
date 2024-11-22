extends Area2D
class_name AreaEffacer

var liaisons : Array[Liaison]
var hitbox : CollisionCercleVisible

var finie = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox = CollisionCercleVisible.new()
	add_child(hitbox)
	area_entered.connect(ajout_liaison)
	area_exited.connect(enlever_liaison)

func ajout_liaison(liaison):
	if liaison == Liaison :
		liaisons.append(liaison)

func enlever_liaison(liaison):
	if liaison == Liaison :
		liaisons.erase(liaison)

func fin():
	finie = true
	hitbox.finie = true

func _process(delta: float) -> void:
	if finie :
		if hitbox.modulate.a < 0.01 :
			queue_free()
