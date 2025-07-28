extends Sprite2D

@export var bruit := FastNoiseLite.new()
@export var vitesse_z := 1.0

@export var hauteur := 512
@export var largeur := 512


var incretif := true

var index_z := 0.0

func _process(delta: float) -> void:
	index_z += delta * vitesse_z
	texture.noise.offset.z = index_z
