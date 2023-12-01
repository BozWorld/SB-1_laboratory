extends Node2D

@export var obj: PackedScene
@export var spawn_location: PathFollow2D
@export var SpawnTimer: Timer
@export var StopTimer: int = 0
var randomValue = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	randomValue= randf_range(0.4,0.8)
	if StopTimer >= 100 :
		SpawnTimer.stop()
	pass



func _on_spawntimer_timeout() -> void:
	var objspawned = obj.instantiate()
	var rand = randf_range(0.1,3)
	
	objspawned.scale = Vector2(rand,rand)
	objspawned.mass = rand

	spawn_location.progress_ratio = randf()
	objspawned.position = spawn_location.position
	StopTimer +=1
	add_child(objspawned)
