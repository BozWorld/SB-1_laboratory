extends Node2D
class_name JoyeuxBaton

var actif := false
var actif_un := false
var actif_deux := false
var position_stick := Vector2.ZERO
var position_levier := 0.0

var doigt_suivi : float

@export var grande_couleur : Color
@export var petite_couleur : Color
@export var gauche := true
@export var vertical_deux := true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch :
		if (gauche and event.position.x < 576.0) or (!gauche and event.position.x > 576.0):
			if event.double_tap and event.pressed :
				position = event.position
				position_levier = 0.0
				actif = true
				actif_deux = true
				doigt_suivi = event.index
			elif event.pressed and !actif:
				position = event.position
				position_stick = Vector2.ZERO
				actif = true
				actif_un = true
				doigt_suivi = event.index
			elif !event.pressed and event.index == doigt_suivi: 
				position_stick = Vector2.ZERO
				position_levier = 0.0
				actif = false
				actif_un = false
				actif_deux = false
	
	if event is InputEventScreenDrag :
		if event.index == doigt_suivi :
			if actif_deux :
				if vertical_deux :
					position_levier = event.position.y - position.y
				else :
					position_levier = event.position.x - position.x
				position_levier = clampf(position_levier, -200.0, 200.0)
					
			elif actif_un :
				position_stick = event.position - position
				if position_stick.length() > 200.0 :
					position_stick = position_stick.limit_length(200.0)


func _process(delta: float) -> void:
	#if actif :
		queue_redraw()

func _draw() -> void:
	if actif_deux :
		if vertical_deux :
			draw_line(Vector2(0.0,-200.0), Vector2(0.0,200.0), grande_couleur, 20.0)
			draw_line(Vector2(-44.0,position_levier), Vector2(44.0, position_levier), petite_couleur, 44.0)
		else :
			draw_line(Vector2(-200.0,0.0), Vector2(200.0,0.0), grande_couleur, 20.0)
			draw_line(Vector2(position_levier, -44.0), Vector2(position_levier, 44.0), petite_couleur, 44.0)
			
			
	elif actif_un :
		draw_circle(Vector2.ZERO, 200.0, grande_couleur, true)
		draw_circle(position_stick, 44.0, petite_couleur, true)

func prendreInput():
	return position_stick/400.0

func prendreInputDeux():
	return position_levier/400.0
