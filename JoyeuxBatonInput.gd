extends Node2D
class_name JoyeuxBatonInput

var actif := false
var actif_un := false
var actif_deux := false
var position_stick := Vector2.ZERO
var position_levier := 0.0

var der_pos_s := Vector2.ZERO
var der_pos_l := 0.0

var doigt_suivi : float

var affiche1 := false
var affiche2 := false

@export var input_haut : StringName
@export var input_bas : StringName
@export var input_gauche : StringName
@export var input_droite : StringName

@export var input_levier_gauche : StringName
@export var input_levier_droite : StringName

@export var grande_couleur : Color
@export var petite_couleur : Color
@export var pos_gauche := true
@export var vertical_deux := true

@export var zone_morte := 0.5

func appelInputAxe(posipi : StringName, negapi : StringName, puissance := 0.0):
	if puissance > zone_morte :
		
		Input.action_release(negapi)
		Input.action_press(posipi, puissance)
	
	elif puissance < -zone_morte :
		Input.action_release(posipi)
		Input.action_press(negapi, puissance)
	
	else :
		Input.action_press(posipi, 0.0)
		Input.action_press(negapi, 0.0)
		Input.action_release(posipi)
		Input.action_release(negapi)
		
	
	#print(Input.get_action_strength(negapi))

func appelInputVecteur(h_posipi : StringName, h_negapi : StringName, v_posipi : StringName, v_negapi : StringName, vecteur_puissance := Vector2.ZERO):
	appelInputAxe(h_posipi, h_negapi, vecteur_puissance.x )
	appelInputAxe(v_posipi, v_negapi, vecteur_puissance.y )
	print("==========
	InputJoystick : 
		x : " + str(vecteur_puissance.x) + "
		y : " + str(vecteur_puissance.y)
			)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch :
		if (pos_gauche and event.position.x < 576.0) or (!pos_gauche and event.position.x > 576.0):
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
	
	if !actif_un and position_stick.length() != 0.0:
		if position_stick.length() * 0.005 > zone_morte:
			position_stick = position_stick.lerp(Vector2.ZERO, 0.2)
		else:
			position_stick = Vector2.ZERO
	
	if !actif_deux and abs(position_levier) != 0.0 :
		if abs(position_levier) * 0.005 > zone_morte:
			position_levier = position_levier * 0.8
		else :
			position_levier = 0.0
	
	if der_pos_s != position_stick :
		#print(position_stick * 0.005)
		appelInputVecteur(input_droite, input_gauche, input_bas, input_haut, position_stick * 0.005)
	if der_pos_l != position_levier :
		appelInputAxe(input_levier_droite, input_levier_gauche, position_levier * 0.005)
	
	
	der_pos_s = position_stick
	der_pos_l = position_levier
	
	queue_redraw()

func _draw() -> void:
	if !actif_un and abs(position_levier) > zone_morte :
		if vertical_deux :
			draw_line(Vector2(0.0,-200.0), Vector2(0.0,200.0), grande_couleur, 20.0)
			draw_line(Vector2(-44.0,position_levier), Vector2(44.0, position_levier), petite_couleur, 44.0)
		else :
			draw_line(Vector2(-200.0,0.0), Vector2(200.0,0.0), grande_couleur, 20.0)
			draw_line(Vector2(position_levier, -44.0), Vector2(position_levier, 44.0), petite_couleur, 44.0)
			
			
	elif !actif_deux and position_stick.length() > zone_morte :
		draw_circle(Vector2.ZERO, 222.0, grande_couleur, true)
		draw_circle(position_stick, 44.0, petite_couleur, true)

func prendreInput():
	return position_stick * 0.005

func prendreInputDeux():
	return position_levier * 0.005
