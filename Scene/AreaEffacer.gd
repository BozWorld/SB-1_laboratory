extends Area2D
class_name AreaEffacer

var liaisons : Array[Liaison]
var hitbox : CollisionCercleVisible

var finie = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox = CollisionCercleVisible.new()
	add_child(hitbox)
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	body_entered.connect(on_body_entered)

func on_area_entered(area : Area2D):
	if area == Liaison :
		ajout_liaison(area)

func on_area_exited(area : Area2D):
	if area == Liaison and liaisons.has(area):
		enlever_liaison(area)

func on_body_entered(body : Node2D):
	pass

func ajout_liaison(liaison):
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
