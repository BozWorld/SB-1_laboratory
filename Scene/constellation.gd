extends Node2D
class_name Constellation

var etoiles : Array[Etoile]
var liaisons : Array[Liaison]

var premiere_etoile : Etoile

# en miliseconde
var temps_dernier_ajout : int
var temps_nouvel_ajout : int


func _ready():
	temps_dernier_ajout = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
		#
	#queue_redraw()

#func _draw() -> void:
	#var precedente_etoile : Etoile
	#for etoile in etoiles :
		#if precedente_etoile :
			#draw_line(global_to_local(precedente_etoile.position), global_to_local(etoile.position),precedente_etoile.couleur.blend(etoile.couleur),2)
		#precedente_etoile = etoile


func ajout_etoile(etoile : Etoile):
	etoiles.append(etoile)
	
	temps_nouvel_ajout = Time.get_ticks_msec()
	
	var duree_liaison : float = temps_nouvel_ajout - temps_dernier_ajout
	# passage en seconde
	duree_liaison /= 1000.0
	
	var nouvelle_liaison = Liaison.new()
	liaisons.append(nouvelle_liaison)
	nouvelle_liaison.etoile1 = etoiles[etoiles.size() - 2]
	nouvelle_liaison.etoile2 = etoiles[etoiles.size() - 1]
	nouvelle_liaison.duree = duree_liaison
	add_child(nouvelle_liaison)
	nouvelle_liaison.global_position = etoiles[etoiles.size() - 2].global_position
	nouvelle_liaison.active = true
	
	temps_dernier_ajout = temps_nouvel_ajout


#func global_to_local(global_position : Vector2):
	#var local : Vector2
	#local = global_position - premiere_etoile.position
	#return local
