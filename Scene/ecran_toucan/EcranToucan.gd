extends Node2D

@export var obj: PackedScene
@export var spawn_location: PathFollow2D
@export_category("Timer de Spawn")
@export var spawn_timer: Timer
@export var _stop: int = 100
@export_range(0,10,0.1,"or_greater") var _frequence = 1.0
@export_range(0,5,0.05, "or_greater") var _incertitude = 0.0
@export var _formule_evolution : String = "x"

var expression_evolution = Expression.new()

var spawn_timer_count : int = 0

func _ready():
	spawn_timer.timeout.connect(_spawn)
	
	expression_evolution.parse(_formule_evolution, ["x"])

func _spawn():
	var objspawned = obj.instantiate()
	var rand = randf_range(0.1,3)
	
	var rand_chroma = randi_range(0,objspawned.chromas.size() - 1)
	
	objspawned.scale = Vector2(rand,rand)
	objspawned.mass = rand
	
	objspawned._change_chroma(rand_chroma)

	spawn_location.progress_ratio = randf()
	objspawned.position = spawn_location.position
	add_child(objspawned)
	
	_comptabilisation()
	
func _comptabilisation():
	spawn_timer_count += 1
	if spawn_timer_count >= _stop :
		spawn_timer.stop()
		return
	
	var prochain_delai = _frequence + randf_range(-_incertitude, _incertitude)
	_frequence = expression_evolution.execute([prochain_delai])
	spawn_timer.start(prochain_delai)
	
