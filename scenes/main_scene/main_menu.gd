extends Node3D


func _on_play_button_pressed() -> void:
    # Changer vers la scène de testing
    get_tree().change_scene_to_file("res://scenes/vrac_scene/testing.tscn")


func _on_quit_button_pressed() -> void:
    # Quitter l'application
    get_tree().quit()
    pass # Replace with function body.
