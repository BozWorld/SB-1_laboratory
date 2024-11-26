extends Node2D

@export var art: Array = []
@export var count: int = 5
@export var min_dist: Vector2 = Vector2(100,100)
var sprite = preload("res://Scene/sprite.tscn")

func _ready():
	spawn_art()

func spawn_art():
	for i in range(count):
		var sprite_instance =  sprite.instantiate()
		var new_pos: Vector2
		var position_is_valid = false
		while not position_is_valid:
			if art.size() > 0 :
				new_pos = art[i-1].position + Vector2(randf_range(0,200), randf_range(0,200))
			else :
				new_pos = Vector2(randf_range(0,400),randf_range(20,400))
			position_is_valid = is_position_valid(new_pos)
		sprite_instance.position = new_pos
		print("ggo")
		add_child(sprite_instance)
		#var texture = mesh.get_surface_override_material(0)
		#.set_surface_override(0).albedo_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		art.append(sprite_instance)
func is_position_valid(new_pos: Vector2) -> bool:
	for sprt in art:
		if sprt.position.distance_to(new_pos) < min_dist.x:
			return false
	return true
