extends Node2D

@export var obj: PackedScene
@export var spawn_location: PathFollow2D
@export var SpawnTimer: Timer
@export var StopTimer: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if StopTimer >= 100 :
		SpawnTimer.stop()
	pass



func _on_spawntimer_timeout() -> void:
	var objspawned = obj.instantiate()
	var rand = randf_range(0.1,3)
	
	var rand_chroma = randi_range(0,objspawned.chromas.size() - 1)
	
	objspawned.scale = Vector2(rand,rand)
	objspawned.mass = rand
	
	objspawned._change_chroma(rand_chroma)

	spawn_location.progress_ratio = randf()
	objspawned.position = spawn_location.position
	StopTimer +=1
	add_child(objspawned)
