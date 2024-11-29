extends Node3D

var base_island_scene = preload("res://scenes/prefab/post_processing_testing/Terrain.tscn")

@export var cube_size: Vector3 = Vector3(300,0,300)
@export var island_count = 5
@export var min_dist: Vector3 = Vector3(10,0,30)
@export var array: ArrayMesh
@export var color: Color
var island_list: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_island()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_island():
	for i in range(island_count):
		var island_instance = base_island_scene.instantiate()
		var new_pos: Vector3
		var new_scale: Vector3
		var position_is_valid = false
		var scale_is_valid = false
		while not position_is_valid:
			if island_list.size() > 0: 
				new_pos = island_list[i-1].transform.origin + Vector3(randf_range(-35,35), 0, randf_range(-35,35))
			else:
				new_pos = Vector3(randf_range(-cube_size.x / 2, cube_size.x / 2), 0, randf_range(-cube_size.z / 2, cube_size.z / 2))
			new_pos.x = clamp(new_pos.x, -cube_size.x/2, cube_size.x/2)
			new_pos.z = clamp(new_pos.z, -cube_size.z/2, cube_size.z/2)
			position_is_valid = is_position_valid(new_pos)
		while not scale_is_valid:
			new_scale.x = randf_range(1,3)
			new_scale.z = randf_range(1,2)
			new_scale.y = randf_range(1,3)
			#new_scale.x = clamp(new_scale.x,1,2)set_
			#new_scale.z = clamp(new_scale.z,1,2)
			print(new_scale)
			scale_is_valid = is_scale_valid(new_scale)		
		island_instance.transform.origin = new_pos
		island_instance.scale = new_scale
		var mesh = island_instance.get_child(0).mesh
		var texture: Material = mesh.surface_get_material(0)
		texture.albedo_color = Color.from_hsv(randf_range(0.0, 1.0),randf_range(0.0, 1.0),randf_range(0.0, 1.0))# Teinte (Hue), couverture complète du spectre.
			#print("voici le nouveau scale" +  str(island_instance.scale))
		island_instance.get_child(0).mesh.surface_set_material(0,texture)
		print(island_instance.get_child(0).mesh.surface_get_material(0))
		add_child(island_instance)
		#var texture = mesh.get_surface_override_material(0)
		#.set_surface_override(0).albedo_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		island_list.append(island_instance)
	return
	
func is_position_valid(new_pos: Vector3) -> bool:
	for island in island_list:
		if island.transform.origin.distance_to(new_pos) < min_dist.x:
			return false
	return true

func is_scale_valid(new_scale:Vector3) -> bool:
	for island in island_list: 
		if island.scale == new_scale :
			return false
	return true
