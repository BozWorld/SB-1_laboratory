extends Attribut3D

@export var frequence_tir := 1.0
var index := 0.0

@export var scene_missile := preload("res://Scene/Vaisseau/missile.tscn")

@onready var boite_missiles = get_tree().get_first_node_in_group("BoiteMissiles")

func tir():
	var nouveau_missile = scene_missile.instantiate()
	nouveau_missile.transform = global_transform
	boite_missiles.add_child(nouveau_missile)
	nouveau_missile.vitesse = 20.0
	nouveau_missile.velocite = parent.velocite
	nouveau_missile.range_depop = 131.2
func logiqueLanceMissiles(delta):
	if index < frequence_tir :
		index += delta
	else :
		if Input.is_action_pressed("tir"):
			tir()
			index = 0.0
