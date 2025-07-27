extends Node3D

@export var score_label: RichTextLabel
@export var score_control: Control
@export var final_score_label: RichTextLabel
@export var final_score_control: Control
@export var player: NodePath
# Variables du timer
var game_timer: float = 0.0
var is_timer_running: bool = false
var game_started: bool = false
@export var rings: Array[NodePath] = []
@export var last_island: Node3D
var current_ring_index: int = 0

func _ready():
	for i in rings.size():
		var ring = get_node(rings[i])
		ring.ring_order = i
	# Initialiser l'affichage
	final_score_control.hide()
	update_score_display()

func ring_passed(ring_order: int):
	if ring_order == current_ring_index:
		current_ring_index += 1
		print("Ring passed: ", ring_order)

		if current_ring_index < rings.size():
			get_node(rings[current_ring_index]).set_active(true)
			print("Next ring activated: ", current_ring_index)
		
		if current_ring_index == rings.size():
			print("All rings passed!")
			last_island.set_landing_available(true)

func level_completed():
	print("Level completed! Final time: ", format_time(game_timer))
	stop_timer()
	score_control.hide()
	final_score_control.show()
	final_score_label.text = "Your final score is: " + format_time(game_timer) + "!!!"
	# Option 1: Si le nœud "plane" est directement le joueur
	get_node(player).set_physics_process(false)
	
	# OU Option 2: Si vous connaissez le nom correct du nœud enfant
	# get_node(player).get_node("NomCorrect").set_physics_process(false)

func _physics_process(delta: float) -> void:
	# Démarrer automatiquement le timer au premier frame
	if not game_started:
		start_timer()
		game_started = true
	
	# Mettre à jour le timer si il tourne
	if is_timer_running:
		game_timer += delta
		update_score_display()

func start_timer():
	"""Démarre le timer de jeu"""
	is_timer_running = true
	game_timer = 0.0
	print("Timer démarré !")

func stop_timer():
	"""Arrête le timer de jeu"""
	is_timer_running = false
	print("Timer arrêté ! Temps final: ", format_time(game_timer))

func reset_timer():
	"""Remet le timer à zéro"""
	game_timer = 0.0
	is_timer_running = false
	update_score_display()
	print("Timer remis à zéro")

func format_time(time_seconds: float) -> String:
	"""Formate le temps en format MM:SS.ms"""
	var minutes = int(time_seconds) / 60
	var seconds = int(time_seconds) % 60
	var milliseconds = int((time_seconds - int(time_seconds)) * 100)
	
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func update_score_display():
	"""Met à jour l'affichage du score"""
	if score_label:
		var formatted_time = format_time(game_timer)
		score_label.text = "Your current score is: " + formatted_time

func get_current_time() -> float:
	"""Retourne le temps actuel pour d'autres scripts"""
	return game_timer


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	# Combinaison Ctrl+R pour réinitialiser directement
	if event is InputEventKey and event.pressed and event.keycode == KEY_R and event.ctrl_pressed:
		get_tree().reload_current_scene()
