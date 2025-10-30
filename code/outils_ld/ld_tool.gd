@tool
extends Node3D


@export var ld_list : LDList

@export var mesh : Mesh

@export var player : CharacterBody3D

var ld_blocs : Array[MeshInstance3D]

func _ready() -> void:
	_setup()
	if !ld_list.array_points.is_empty() :
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

func _new_bloc(_position: Vector3):
	var nouveau_mesh := MeshInstance3D.new()
	nouveau_mesh.mesh = mesh
	add_child(nouveau_mesh)
	nouveau_mesh.position = _position
	ld_blocs.append(nouveau_mesh)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("LD_marquer"):
		ld_list._add_point(player.global_position)
		ResourceSaver.save(ld_list, "res://code/outils_ld/liste1.tres")
