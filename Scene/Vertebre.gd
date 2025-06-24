extends Node3D
class_name Vertebre

@export var post_distance := 0.3
var vertebre_precedente : Node3D
var vertebre_suivante : Node3D

@export var modele : Mesh
var mesh : MeshInstance3D

func _ready() -> void:
	mesh = MeshInstance3D.new()
	if !modele :
		mesh.mesh = SphereMesh.new()
		mesh.mesh.radius = 0.4
		mesh.mesh.height = 0.8
	else :
		mesh.mesh = modele
	
	if !mesh.mesh.material :
		mesh.mesh.material = StandardMaterial3D.new()
	add_child(mesh)

func tenirVerterbreSuivante():
	if vertebre_suivante :
		var distance_vertebre = vertebre_suivante.global_position - global_position
		if distance_vertebre.length() != post_distance :
			vertebre_suivante.global_position = global_position + distance_vertebre.normalized() * post_distance


func _physics_process(delta: float) -> void:
	tenirVerterbreSuivante()
	if vertebre_precedente :
		look_at(vertebre_precedente.position)
		if vertebre_suivante :
			if to_local(vertebre_suivante.global_position).z < -0.70 :
				mesh.mesh.material.albedo_color = Color.RED
				var nouvelle_pos = to_local(vertebre_suivante.global_position)
				nouvelle_pos.z = -0.70
				vertebre_suivante.global_position = to_global(nouvelle_pos)
				tenirVerterbreSuivante()
				#print(global_position.angle_to(vertebre_suivante.global_position))
			else :
				mesh.mesh.material.albedo_color = Color.WHITE
	
