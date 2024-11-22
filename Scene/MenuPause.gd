extends Control
class_name MenuPause

# Est ce que le menu met le jeu en pause
const FAIT_PAUSE = true

var ancien_mouse_mode

var main 

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	main = GestionnaireDeConstellations.main
	
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
	
	main.fermer_menu()
	
	queue_free()

func pause():
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("echap"):
		continuer()

func _on_continuer_button_up() -> void:
	continuer()


func _on_recommencer_button_up() -> void:
	continuer()
	get_tree().reload_current_scene()
	

func _on_quitter_button_up() -> void:
	get_tree().quit()
