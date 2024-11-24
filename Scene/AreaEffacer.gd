extends Area2D
class_name AreaEffacer

var etoiles : Array[Etoile]
var hitbox : CollisionCercleVisible

var finie = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox = CollisionCercleVisible.new()
	add_child(hitbox)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body : Node2D):
	if body is CorpsEtoile :
		ajout_etoile(body.parent)

func on_body_exited(body : Node2D):
	if body is CorpsEtoile :
		enlever_etoile(body.parent)

func ajout_etoile(etoile):
	etoiles.append(etoile)

func enlever_etoile(etoile):
	if etoiles.has(etoile):
		etoiles.erase(etoile)

func fin():
	
	for etoile in etoiles :
		etoile.effacer()
	
	finie = true
	hitbox.finie = true

func _process(delta: float) -> void:
	if finie :
		if hitbox.modulate.a < 0.01 :
			queue_free()
