@tool
extends Node2D

@export var frequence : float = 6.0:
	set(nouvelle_frequence): 
		taille = 0.7 + (1.0/(octave*12.0 + nouvelle_frequence))*200
		frequence = nouvelle_frequence
@export var octave : float = 3.0:
	set(nouvelle_octave): 
		taille = 0.7 + (1.0/(nouvelle_octave*12.0 + frequence))*200
		octave = nouvelle_octave
		

@export var couleur : Color = Color(1.0,1.0,1.0)

@onready var synth_meep : AudioStreamPlayer2D = $SyntheMeep
@onready var synth_vibre : AudioStreamPlayer2D = $SyntheVibre
@onready var synth_clope : AudioStreamPlayer2D = $SyntheClope

var brille = false

var taille : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var volume_meep = couleur.r8
	var volume_vibre = couleur.g8
	var volume_clope = couleur.b8
	
	var mod_meep = (255.0 - volume_meep)/10.0
	var mod_vibre = (255.0 - volume_vibre)/10.0
	var mod_clope = (255.0 - volume_clope)/10.0
	
	synth_meep.volume_db -= mod_meep
	synth_vibre.volume_db -= mod_vibre
	synth_clope.volume_db -= mod_clope
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_process(delta)
	
	queue_redraw()

func _draw():
	draw_circle(Vector2(0,0), taille, couleur, true)
	
	if brille :
		draw_circle(Vector2(0,0), taille*2, Color(255,255,255), false, 3)

func editor_process(delta):
	pass
	
	
	
