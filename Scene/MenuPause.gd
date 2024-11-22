extends Control
class_name MenuPause

# Est ce que le menu met le jeu en pause
const FAIT_PAUSE = false

var ancien_mouse_mode

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	
	if FAIT_PAUSE :
		pause()
	
	anim_player.play("blur_on")
	
	await anim_player.animation_finished
	
	ancien_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	

func continuer():
	if FAIT_PAUSE :
		get_tree().paused = false
	
	Input.mouse_mode = ancien_mouse_mode
	ancien_mouse_mode = null
	
	anim_player.play("blur_off")
	
	await anim_player.animation_finished
	
	queue_free()

func pause():
	get_tree().paused = true




func _on_continuer_button_up() -> void:
	continuer()


func _on_recommencer_button_up() -> void:
	get_tree().reload_current_scene()
	continuer()

func _on_quitter_button_up() -> void:
	get_tree().quit()
