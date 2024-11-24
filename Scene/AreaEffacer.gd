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
	if body is Etoile :
		ajout_etoile(body)

func on_body_exited(body : Node2D):
	if body is Etoile and etoiles.has(body):
		enlever_etoile(body)

func ajout_etoile(etoile):
	etoiles.append(etoile)

func enlever_etoile(etoile):
	if etoile == Etoile :
		etoiles.erase(etoile)

func fin():
	finie = true
	hitbox.finie = true

func _process(delta: float) -> void:
	if finie :
		if hitbox.modulate.a < 0.01 :
			queue_free()
