@tool
extends Node3D

## Efface les marques du niveau
@export_tool_button("Clear Level", "Eraser") var cleaning := _clear_list

## Le nom qui sera donné au fichier qui retient les données des marques, il vaut mieux le changer
@export var nom_fichier:= "Liste"

## Resource utilisée pour mémoriser les marques, autant sélectionner celle qui sera désignée par le nom
@export var ld_list : LDList

## Mesh affichés sur les points marqués
@export var mesh : Mesh

## Reference au player
@export var player : CharacterBody3D

# Array des mesh instances des marques
var ld_blocs : Array[MeshInstance3D]


func _ready() -> void:
	_setup()
	if !ld_list.array_points.is_empty() :
		_rebuild_meshes()

func _rebuild_meshes():
	_clean_array()
	for point in ld_list.array_points :
		_new_bloc(point)

func _setup():
	ld_list.points_cleared.connect(_clean_array)
	ld_list.point_added.connect(_new_bloc)

func _clean_array():
	for bloc in ld_blocs :
		bloc.queue_free()
	ld_blocs.clear()

func _new_bloc(_transform: Transform3D):
	var nouveau_mesh := MeshInstance3D.new()
	nouveau_mesh.mesh = mesh
	add_child(nouveau_mesh)
	nouveau_mesh.transform = _transform
	ld_blocs.append(nouveau_mesh)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("LD_marquer"):
		ld_list._add_point(player.global_transform)
		ResourceSaver.save(ld_list, "res://code/outils_ld/data/" + nom_fichier + ".tres")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if ld_list.array_points.size() != ld_blocs.size() :
			_rebuild_meshes()

func _clear_list():
	ld_list._clear_list(nom_fichier)
	_clean_array()
