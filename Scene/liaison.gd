extends Node2D
class_name Liaison

var etoile1 : Etoile
var etoile2 : Etoile

var active = false

var duree : float

func _ready():
	etoile1.liaisons.append(self)
	etoile2.liaisons.append(self)

func _process(delta: float) -> void:
	if active :
		queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0,0), etoile2.position - etoile1.position, etoile1.couleur.blend(etoile2.couleur), 2)

func propagation(etoile : Etoile):
	
	#print("
	#[" + name + "]" + "Reception de la part de " + etoile.name)
	
	var timer = TimerUnique.new()
	timer.add_to_group("TimersPropagation")
	timer.wait_time = duree
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	if etoile == etoile1:
		etoile2.reception_propagation(self)
		
		#print("
	#[" + name + "]" + "Envoi à " + etoile2.name)
	
	elif etoile == etoile2:
		etoile1.reception_propagation(self)
		
		#print("
	#[" + name + "]" + "Envoi à " + etoile1.name)
	
