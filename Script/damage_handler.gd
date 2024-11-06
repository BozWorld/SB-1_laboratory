extends Node

var joueureuse : Node3D = null :
	set(value) :
		print(value, " , voici qui je suis !")
		joueureuse = value

var index_ennemies_do_not_touch = 0
var ennemies : Array[Node3D]

func connexion_hitbox():
	if joueureuse:
		ennemies[index_ennemies_do_not_touch].attack_connect.connect(joueureuse._take_damage.bind())

func add_ennemies(ennemie):
	print(ennemie, " mon ennemi est !") 
	ennemies.append(ennemie)
	connexion_hitbox()
	index_ennemies_do_not_touch += 1
