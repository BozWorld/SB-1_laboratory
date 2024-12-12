extends AudioStreamPlayer2D
class_name SynthPlayer

@onready var parent : Etoile = get_parent() 

@export var synth : Synth

# Octave de 1 à 5
var octave : int
# Note de 1 à 12
var note : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	octave = parent.octave - 1
	note = parent.frequence - 1
	call_deferred("_init_stream")
	

func _init_stream():
	pass
