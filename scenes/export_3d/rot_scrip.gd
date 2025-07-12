xtends Node3D

# Vitesse de rotation en degrés par seconde
@export var rotation_speed = 30.0  # Change la valeur pour ajuster la vitesse

func _process(delta: float) -> void:
	# Rotation autour de l'axe Y (vertical)
	rotate_y(deg_to_rad(rotation_speed * delta))
