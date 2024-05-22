extends Node2D

@onready var persos = [$paPerso, $Perso1, $Perso2, $Perso3, $Perso4, $Perso5, $paPerso2]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_nombre_persos_nombre_change(index):
	if index <= 5 :
		persos[index].show()
		persos[index + 1].hide()
		
func _on_reset(cap, index : int = 0):
	if index == 0 :
		persos[1].hide()
		persos[2].hide()
		persos[3].hide()
		persos[4].hide()
		persos[5].hide()
	if index <= cap :
		persos[index].show()
		index += 1
		_on_reset(cap, index)
	


func _on_slider_zoom_value_changed(value):
	create_tween().tween_property(self, "scale", Vector2(1+value*0.01,1+value*0.01),0.5)
