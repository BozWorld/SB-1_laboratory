@tool
extends Node2D
class_name Etoile

@export_range(1,12) var frequence : int = 0:
	set(nouvelle_frequence): 
		taille = 0.7 + (1.0/(octave*12.0 + nouvelle_frequence))*200
		frequence = nouvelle_frequence
@export_range(1,5) var octave : int = 1:
	set(nouvelle_octave): 
		taille = 0.7 + (1.0/(nouvelle_octave*12.0 + frequence))*200
		octave = nouvelle_octave
		

@export var couleur : Color = Color(1.0,1.0,1.0)

@onready var synth_bleu : AudioStreamPlayer2D = $Bleu
@onready var synth_vert : AudioStreamPlayer2D = $Vert
@onready var synth_rouge : AudioStreamPlayer2D = $Rouge

@onready var gest_particules = $Particules

var brille = false

var selectionnee = false


var taille : float

var liaisons : Array[Liaison]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# On vient recupérer les valeurs de RGB, la présence de chacune des couleurs défini la présence d'un synth
	var volume_bleu = couleur.b8
	var volume_vert = couleur.g8
	var volume_rouge = couleur.r8
	
	var mod_bleu = (256.0 - volume_bleu)/10.0
	var mod_vert = (256.0 - volume_vert)/10.0
	var mod_rouge = (256.0 - volume_rouge)/10.0
	
	synth_bleu.volume_db -= mod_bleu
	synth_vert.volume_db -= mod_vert
	synth_rouge.volume_db -= mod_rouge

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_process(delta)
	
	queue_redraw()

func _draw():
	draw_circle(Vector2(0,0), taille, couleur, true)
	
	#if brille :
		#draw_circle(Vector2(0,0), taille*2, Color(255,255,255), false, 3)

func editor_process(delta):
	pass
	
func clean_array_liaisons():
	for liaison in liaisons:
		if !is_instance_valid(liaison):
			liaisons.erase(liaison)


func faire_sonner():
	
	clean_array_liaisons()
	
	synth_rouge.play()
	synth_bleu.play()
	synth_vert.play()
	
	gest_particules._nouvelle_particule(couleur)



func _on_corps_etoile_mouse_entered() -> void:
	#if !selectionnee :
		#GestionnaireDeConstellations.ajout_etoile(self)
		#faire_sonner()
	#elif selectionnee :
	GestionnaireDeConstellations.reselection_etoile(self)

func clic_sonner():
	faire_sonner()
	
	#print("
#["+ name + "] :" +"Sonne par clic")

	if liaisons.size():
		for liaison in liaisons :
			if liaison != null:
				liaison.propagation(self)

func reception_propagation(liaison_emettrice : Liaison):
	faire_sonner()
	
	#print("
#[" + name + "]" + "Reception de la part de " + liaison_emettrice.name)

	if liaisons.size() > 1:
		for liaison in liaisons:
			if liaison != null and liaison != liaison_emettrice:
				liaison.propagation(self)

func deselection(liaison_quittee : Liaison):
	liaisons.erase(liaison_quittee)
	clean_array_liaisons()

func deselection_totale():
	clean_array_liaisons()
	for liaison in liaisons:
		if is_instance_valid(liaison):
			liaison.parent.enlever_etoile(self)
		else :
			liaisons.erase(liaison)
	liaisons.clear()
