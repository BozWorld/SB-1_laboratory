@tool
extends Node2D
class_name Etoile

@export var frequence : float = 0.0:
	set(nouvelle_frequence): 
		taille = 0.7 + (1.0/(octave*12.0 + nouvelle_frequence))*200
		frequence = nouvelle_frequence
@export var octave : float = 0.0:
	set(nouvelle_octave): 
		taille = 0.7 + (1.0/(nouvelle_octave*12.0 + frequence))*200
		octave = nouvelle_octave
		

@export var couleur : Color = Color(1.0,1.0,1.0)

@onready var synth_meep : AudioStreamPlayer2D = $SyntheMeep
@onready var synth_vibre : AudioStreamPlayer2D = $SyntheVibre
@onready var synth_clope : AudioStreamPlayer2D = $SyntheClope

@onready var gest_particules = $Particules

var brille = false

var selectionnee = false


var taille : float

var liaisons : Array[Liaison]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var volume_meep = couleur.b8
	var volume_vibre = couleur.g8
	var volume_clope = couleur.r8
	
	var mod_meep = (255.0 - volume_meep)/10.0
	var mod_vibre = (255.0 - volume_vibre)/10.0
	var mod_clope = (255.0 - volume_clope)/10.0
	
	synth_meep.volume_db -= mod_meep
	synth_vibre.volume_db -= mod_vibre
	synth_clope.volume_db -= mod_clope
	
	var mod_pitch = (octave*12.0 + frequence -37)*0.1
	
	synth_meep.pitch_scale -= mod_pitch
	synth_vibre.pitch_scale -= mod_pitch
	synth_clope.pitch_scale -= mod_pitch

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
	
	synth_clope.play()
	synth_meep.play()
	synth_vibre.play()
	
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
	liaisons.remove_at(liaisons.find(liaison_quittee))
	clean_array_liaisons()

func effacer():
	for liaison in liaisons:
		liaison.parent.enlever_etoile(self)
	liaisons.clear()
