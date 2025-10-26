extends Node3D
class_name Attribut3D

var parent : Node3D = self
var attribut_parent : Attribut3D 

var enfant_direct = true

func _ready() -> void:
	chercherParents()
	

func chercherParents():
	parent = parent.get_parent()
	if parent is Attribut3D :
		if enfant_direct :
			attribut_parent = parent
			enfant_direct = false
		return chercherParents()
