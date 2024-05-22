extends Control

var nombre_gens : int = 0

@onready var texte = $HBoxContainer/TextureRect/Label

signal nombre_change
signal reset_gens

# Called when the node enters the scene tree for the first time.
func _ready():
	texte.text = str(nombre_gens)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_button_moins_pressed():
	if nombre_gens > 0 :
		nombre_gens -= 1
	texte.text = str(nombre_gens)
	nombre_change.emit(nombre_gens)


func _on_button_plus_pressed():
	if nombre_gens < 5 :
		nombre_gens += 1
	texte.text = str(nombre_gens)
	nombre_change.emit(nombre_gens)

func reset():
	texte.text = str(nombre_gens)
	reset_gens.emit(nombre_gens)
