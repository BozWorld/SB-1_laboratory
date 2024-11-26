extends Node2D

var menu_ouvert = false
@onready var camera = $Camera2D

var ancien_mouse_mode

@onready var canvas_layer = $Camera2D/CanvasLayer
var scene_menu = preload("res://Scene/menu.tscn")

func _ready() -> void:
	GestionnaireDeConstellations.main = self

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("echap"):
		if !menu_ouvert :
			ouvrir_menu()
	
	if Input.is_action_just_pressed("stop"):
		get_tree().call_group("TimersPropagation","queue_free")

func ouvrir_menu():
	menu_ouvert = true
	camera.bloquee = true
	
	var inst_menu_pause = scene_menu.instantiate()
	inst_menu_pause.name = "Menu"
	canvas_layer.add_child(inst_menu_pause)

func fermer_menu():
	menu_ouvert = false
	camera.bloquee = false

func _process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	if Engine.get_frames_per_second() < GestionnaireDeConstellations.min_fps:
		if get_tree().get_nodes_in_group("ParticulesCercle").size() > 20:
			get_tree().call_group("TimersPropagation","queue_free")
