extends Node2D

@export var obj: PackedScene
@export var spawn_location: PathFollow2D
@export var spawn_timer: Timer
@export var stop_timer: int = 0
var random_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	random_value= randf_range(0.4,0.8)
	if stop_timer >= 100 :
		spawn_timer.stop()
	pass



func _on_spawntimer_timeout() -> void:
	var objspawned = obj.instantiate()
	var rand = randf_range(0.1,3)
	
	objspawned.scale = Vector2(rand,rand)
	objspawned.mass = rand

	spawn_location.progress_ratio = randf()
	objspawned.position = spawn_location.position
	stop_timer +=1
	add_child(objspawned)
