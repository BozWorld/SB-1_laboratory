extends Node2D

@export var step_size: float = 5       # Multiplieur du pas
@export var circle_radius: float = 10   # Taille des "particules"

var pos := Vector2(0,0)
var trail_positions: Array[Vector2] = []

func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	pos = screen_size / 2  # On utilise pos comme référence principale
	queue_redraw()

func _process(delta: float) -> void:
	var old_pos = pos

	# version "flottante" : déplacement aléatoire entre -1 et 1 sur chaque axe
	var xstep = randf_range(-1, 1)
	var ystep = randf_range(-1, 1)
	pos += Vector2(xstep, ystep) * step_size

	if pos != old_pos:
		trail_positions.append(pos)

	queue_redraw()

func _draw() -> void:
	# Trace continue
	for i in range(1, trail_positions.size()):
		draw_line(trail_positions[i - 1], trail_positions[i], Color.WHITE, 5.0)

	# Position actuelle
	draw_circle(pos, circle_radius, Color.RED)
