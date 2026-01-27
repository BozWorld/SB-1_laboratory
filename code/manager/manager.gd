extends Node3D
class_name GameManager

# === SIGNAUX === 
signal game_started
signal game_completed(final_time: float)
signal ordered_ring_passed(ring_index: int)


@export var score_control : Control
# === EXPORT ===
@export var ui_manager: UIManager
@export var player: Node3D
var ordered_rings: Array[OrderedRing] = []
@export var last_island: Node3D
@export var ring_manager: RingManager

# === VARIABLES PRIVÉES ===
var _timer_manager: TimerManager
var _game_state: GameState = GameState.WAITING
var _score_manager: ScoreManager

enum GameState { WAITING, PLAYING, COMPLETED, PAUSED }

# === INITIALISATION ===
func _ready():
	_initialize_manager()
	_connect_signals()
	_setup_initial_state()

func _initialize_manager():
	_timer_manager = TimerManager.new()
	_score_manager = ScoreManager.new()
	add_child(_timer_manager)
	
	

	ring_manager.add_to_group("ring_manager")
	ring_manager.setup_rings()
	ordered_rings = ring_manager.ordered_rings
	ui_manager.set_total_rings(ordered_rings.size(), ring_manager.bonus_rings.size())

func _connect_signals():
	_timer_manager.timer_updated.connect(_on_timer_updated)
	ring_manager.ordered_ring_passed.connect(_on_ordered_ring_passed)
	ring_manager.bonus_ring_passed.connect(_on_bonus_ring_passed)
	ring_manager.all_ordered_rings_completed.connect(_on_all_ordered_rings_completed)

func _setup_initial_state():
	ui_manager.hide_final_score()
	ui_manager.update_score_display(0.0, 0.0)
	_game_state = GameState.WAITING

# === GESTION DU JEU ===
func _physics_process(delta: float) -> void:
	if _game_state == GameState.WAITING:
		_start_game()
	
	if _game_state == GameState.PLAYING:
		_timer_manager.update_timer(delta)

func _start_game():
		_game_state = GameState.PLAYING
		_timer_manager.start_timer()
		game_started.emit()
		print("jeu démarée !")

func _complete_game():
	_game_state = GameState.COMPLETED
	var final_time = _timer_manager.stop_timer()

	_disable_player()
	if ui_manager:
		ui_manager.show_final_score(final_time)
	
	game_completed.emit(final_time)
	print("Niveau terminé ! temps final: ", _timer_manager.format_time(final_time))

func _disable_player():
	if player:
		player.set_process(false)
		player.set_physics_process(false)

# === GESTIONNAIRE D'ÉVÉNEMENTS ===
func _on_timer_updated(current_time: float):
	if ui_manager:
		ui_manager.update_score_display(current_time, _score_manager.total_score)

func _on_bonus_ring_passed(score: float):
	_score_manager.add_score(score)
	ui_manager.update_bonus_rings(ring_manager.get_bonus_passed_count())

func _on_ordered_ring_passed(ring_index: int, score: float):
	_score_manager.add_score(score)
	ordered_ring_passed.emit(ring_index)
	ui_manager.update_rings(ring_index + 1)
	print("Anneau franchi: ", ring_index)

func _on_all_ordered_rings_completed():
	last_island.set_landing_available(true)
	ui_manager.set_landing_available(true)

# === MÉTHODE PUBLIQUE ===
func get_current_time() -> float:
	return _timer_manager.get_current_time() if _timer_manager else 0.0

func restart_game():
	get_tree().reload_current_scene()

#func _update_debug_info():
	#if debug_ui:
		#var texte_trails:= ""
		#for trail in _trails :
			#texte_trails += trail.get_debug_string() + "
#"
		#debug_ui.text = ( 
			#_flight_physics.get_debug_string() + "\n" +
			#texte_trails + "\n" +
			#_gravity_handler.get_debug_string() + "\n" +
			#_plane_animation.get_debug_string() + "\n" +
			#"Velocite totale: %f.1" % velocity.length()
		#)


# === INPUT ===
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		restart_game()
	elif Input.is_action_just_pressed("hide_ui"):
		if %AideDatas:
			%AideDatas.queue_free()
		ui_manager.data_control.visible = not ui_manager.data_control.visible
	elif Input.is_action_just_pressed("inv_axe1") or Input.is_action_just_pressed("inv_axe2"):
		if Input.is_action_pressed("inv_axe1") and Input.is_action_pressed("inv_axe2"):
			player.inv_pitch = !player.inv_pitch
	elif Input.is_action_just_pressed("input_map"):
		if %InputMap.visible:
			%InputMap.hide()
			%score_control.show()
		else:
			if %AideInput:
				%AideInput.queue_free()
			%InputMap.show()
			%score_control.hide()


func _on_button_pressed() -> void:
	restart_game()
