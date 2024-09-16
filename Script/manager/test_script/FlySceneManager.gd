extends Node2D

@export var obj: PackedScene
@export var spawn_location: PathFollow2D
@export var spawn_timer: Timer
@export var spawn_timer_stop: int = 100
@export_range(0,10,0.1,"or_greater") var spawn_timer_frequence = 1.0
@export_range(0,5,0.05, "or_greater") var spawn_timer_incertitude = 0.2


var spawn_timer_count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if spawn_timer_count >= spawn_timer_stop :
		spawn_timer.stop()



func _on_spawnspawn_timer_timeout() -> void:
	
	
	var objspawned = obj.instantiate()
	var rand = randf_range(0.1,3)
	
	var rand_chroma = randi_range(0,objspawned.chromas.size() - 1)
	
	objspawned.scale = Vector2(rand,rand)
	objspawned.mass = rand
	
	objspawned._change_chroma(rand_chroma)

	spawn_location.progress_ratio = randf()
	objspawned.position = spawn_location.position
	add_child(objspawned)
	
	spawn_timer_count += 1
	if spawn_timer_count >= spawn_timer_stop :
		spawn_timer.stop()
		return
	
	var prochain_delai : float = spawn_timer_frequence + randf_range(-spawn_timer_incertitude, spawn_timer_incertitude)
	spawn_timer.start(prochain_delai)
	
