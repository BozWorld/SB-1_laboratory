@tool
extends Node2D

@export var frequence : float = 6.0
@export var octave : float = 3.0

@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		editor_process(delta)


func editor_process(delta):
	sprite.scale = Vector2(1.0 + (1.0/(octave*12.0 + frequence))*5.0,1.0 + (1.0/(octave*12.0 + frequence))*5.0)
	
