@tool
extends MeshInstance3D
class_name Vertebre

var scene_gizmo = preload("res://BoiteOutils/Gizmo.tscn")

@export var post_distance := 0.3
var vertebre_precedente : Node3D
var vertebre_suivante : Node3D

var derniere_position := Vector3.ZERO
var derniere_velocite : Vector3

@export var modele : Mesh = SphereMesh.new()
var mesh_articulation : MeshInstance3D

func _ready() -> void:
	initialisation()
	

func initialisation():
	initialisationMesh()

func initialisationMesh():
	mesh_articulation = MeshInstance3D.new()
	if !modele :
		mesh_articulation.mesh = SphereMesh.new()
		mesh_articulation.mesh.radius = 0.4
		mesh_articulation.mesh.height = 0.8
	else :
		mesh_articulation.mesh = modele
	
	if !mesh_articulation.mesh.material :
		mesh_articulation.mesh.material = StandardMaterial3D.new()
	add_child(mesh_articulation)
	
	
	var gizmo = scene_gizmo.instantiate()
	add_child(gizmo)
	gizmo.scale *= post_distance

func tenirVerterbreSuivante():
	if vertebre_suivante :
		var distance_vertebre = vertebre_suivante.global_position - global_position
		if distance_vertebre.length() != post_distance :
			vertebre_suivante.global_position = global_position + distance_vertebre.normalized() * post_distance


func actualisation(delta):
	
	if position != derniere_position :
		derniere_velocite = position - derniere_position
	derniere_position = position
	
	tenirVerterbreSuivante()
	if vertebre_precedente :
		look_at(vertebre_precedente.position)
		if rotation != vertebre_precedente.rotation :
			rotation -= (rotation - vertebre_precedente.rotation)* 0.01 * delta
		if vertebre_suivante :
			if to_local(vertebre_suivante.global_position).z < -0.70 :
				mesh_articulation.mesh.material.albedo_color = Color.RED
				var nouvelle_pos = to_local(vertebre_suivante.global_position)
				nouvelle_pos.z = -0.70
				vertebre_suivante.global_position = to_global(nouvelle_pos)
				tenirVerterbreSuivante()
				#print(global_position.angle_to(vertebre_suivante.global_position))
			else :
				mesh_articulation.mesh.material.albedo_color = Color.WHITE
	elif derniere_velocite :
		look_at(derniere_velocite + position)
	
