extends Node3D
class_name GameManager

# === SIGNAUX === 
signal game_started
signal game_completed(final_time: float)
signal ring_passed(ring_index: int)

# === EXPORT ===
@export var ui_manager: UIManager
@export var player: Node3D
@export var rings: Array[Node3D] = []
@export var last_island: Node3D

# === VARIABLES PRIVÉES ===
var _timer_manager: TimerManager
var _ring_manager: RingManager
var _game_state: GameState = GameState.WAITING

enum GameState { WAITING, PLAYING, COMPLETED, PAUSED }

# === INITIALISATION ===
func _ready():
	_initialize_manager()
	_connect_signals()
	_setup_initial_state()

func _initialize_manager():
	_timer_manager = TimerManager.new()
	_ring_manager = RingManager.new()

	add_child(_timer_manager)
	add_child(_ring_manager)

	_ring_manager.add_to_group("ring_manager")
	_ring_manager.setup_rings(rings)

func _connect_signals():
	_timer_manager.timer_updated.connect(_on_timer_updated)
	_ring_manager.ring_passed.connect(_on_ring_passed)
	_ring_manager.all_rings_completed.connect(_on_all_rings_completed)

func _setup_initial_state():
	ui_manager.hide_final_score()
	ui_manager.update_score_display(0.0)
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
		ui_manager.update_score_display(current_time)

func _on_ring_passed(ring_index: int):
	ring_passed.emit(ring_index)
	print("Anneau franchi: ", ring_index)

func _on_all_rings_completed():
	if last_island:
		last_island.set_landing_available(true)
	print("tout les anneaux franchis !")

# === MÉTHODE PUBLIQUE ===
func get_current_time() -> float:
	return _timer_manager.get_current_time() if _timer_manager else 0.0

func restart_game():
	get_tree().reload_current_scene()



# === INPUT ===
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R and event.ctrl_pressed:
			restart_game()

func _on_button_pressed() -> void:
	restart_game()
