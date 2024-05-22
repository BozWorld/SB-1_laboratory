extends Node

var tween = create_tween()


var skin_actif : int = 1

var memoire_nombre_gens : int = 0
var memoire_zoom : float = 0
var memoire_resolution : float = 50

@onready var interface = $Interface/TextureRect

@onready var bouton_gens = $NombrePersos
@onready var slider_format = $SliderFormat
@onready var slider_zoom = $SliderZoom

@onready var bande_top = $BandeTop
@onready var bande_down = $BandeDown
@onready var bande_gauche = $BandeGauche
@onready var bande_droite = $BandeDroite

@onready var skin1 = preload("res://Asset/Visuel/mecanique_du_coeur/interface_bleue.svg")
@onready var skin2 = preload("res://Asset/Visuel/mecanique_du_coeur/interface_rouge.svg")
@onready var skin3 = preload("res://Asset/Visuel/mecanique_du_coeur/interface_verte.svg")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_format_value_changed(value):
	var valeur = value
	if valeur > 50 :
		valeur = valeur - 50
		create_tween().tween_property(bande_gauche, "scale", Vector2(1,-valeur*0.18),0.5)
		create_tween().tween_property(bande_droite, "scale", Vector2(1,valeur*0.18),0.5)
		create_tween().tween_property(bande_top, "scale", Vector2(1,1),0.5)
		create_tween().tween_property(bande_down, "scale", Vector2(1,1),0.5)

	elif valeur < 50 :
		valeur = 50 - valeur
		create_tween().tween_property(bande_top, "scale", Vector2(1,valeur*0.18),0.5)
		create_tween().tween_property(bande_down, "scale", Vector2(1,-valeur*0.18),0.5)
		create_tween().tween_property(bande_gauche, "scale", Vector2(1,1),0.5)
		create_tween().tween_property(bande_droite, "scale", Vector2(1,1),0.5)


func fin_tour():
	memoire_nombre_gens = bouton_gens.nombre_gens
	memoire_resolution = slider_format.value
	memoire_zoom = slider_zoom.value
	
	if skin_actif == 1 :
		interface.texture = skin2
		skin_actif = 2
	elif skin_actif == 2 :
		interface.texture = skin3
		skin_actif = 3
	elif skin_actif == 3 :
		interface.texture = skin1
		skin_actif = 1
	
	

func reset():
	bouton_gens.nombre_gens = memoire_nombre_gens
	bouton_gens.reset()
	slider_format.value = memoire_resolution
	slider_zoom.value = memoire_zoom
