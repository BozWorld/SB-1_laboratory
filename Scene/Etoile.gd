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
@onready var sprite = $Sprite2D

var taille : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_process(delta)
		queue_redraw()

func _draw():
	draw_circle(Vector2(0,0), taille, couleur, true)

func editor_process(delta):
	pass
	
	
	
