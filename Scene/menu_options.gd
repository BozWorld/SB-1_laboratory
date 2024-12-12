extends Control


@onready var volume_slider = find_child("VolumeSlider")

@onready var minfps_slider = find_child("MinFPSSlider")

@onready var maxfps_slider = find_child("MaxFPSSlider")

@onready var parent_menu = get_parent()

@onready var anim_player : AnimationPlayer = find_child("AnimationPlayer")

func _ready() -> void:
	anim_player.play("menu_on")
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	maxfps_slider.value = Engine.max_fps



func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_resolution_option_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(1152,648))
		4:
			DisplayServer.window_set_size(Vector2i(854,480))
		5:
			DisplayServer.window_set_size(Vector2i(640,360))


func _on_mode_affichage_option_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_max_fps_slider_value_changed(value: float) -> void:
	Engine.max_fps = value


func _on_retour_button_button_up() -> void:
	anim_player.play("menu_off")
	
	await anim_player.animation_finished
	
	parent_menu.fermer_options()
