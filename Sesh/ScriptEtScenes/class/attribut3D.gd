extends Node3D
class_name Attribut3D

@onready var parent : SeshBody = find_parent("*Body")
var attribut_parent : Attribut3D 

func _ready() -> void:
	if parent != get_parent():
		attribut_parent = get_parent()
