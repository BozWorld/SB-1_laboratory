extends Node3D

@export var randonneureuse : Randonneureuse

var occurences : Array[MeshInstance3D]

func _ready() -> void:
	if randonneureuse :
		randonneureuse.pas_effectue.connect(pas)

func pas():
	var nouveau_mesh = MeshInstance3D.new()
	nouveau_mesh.mesh = randonneureuse.mesh.duplicate()
	nouveau_mesh.mesh.material = randonneureuse.mesh.material.duplicate()
	nouveau_mesh.position = randonneureuse.position
	add_child(nouveau_mesh)
	occurences.append(nouveau_mesh)
	
