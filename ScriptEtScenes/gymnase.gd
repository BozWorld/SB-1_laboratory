extends Node3D

var menu_ouvert = false
@onready var regarder = $Perso/Regarder
var min_fps := 30

var ancien_mouse_mode

var inst_menu_pause

@onready var canvas_layer = $Perso/Regarder/HPivot/VPivot/Camera3D/CanvasLayer
var scene_menu = preload("res://Scene/menu.tscn")

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("echap"):
		if !menu_ouvert :
			ouvrir_menu()
		else :
			fermer_menu()
	

func ouvrir_menu():
	menu_ouvert = true
	#regarder.camera_bloquee = true
	
	inst_menu_pause = scene_menu.instantiate()
	inst_menu_pause.name = "Menu"
	canvas_layer.add_child(inst_menu_pause)

func fermer_menu():
	inst_menu_pause.continuer()
	menu_ouvert = false
	#regarder.camera_bloquee = false
