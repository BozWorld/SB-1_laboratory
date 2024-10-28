extends Sprite2D

var masse = 1.0
var hvelocite_init : float = 10
var deplacement_a_gauche : bool = false
var puissance_battement : float = 12
var max_treshold : float = 2

var velocite : Vector2
var acceleration : Vector2

var last_random_tick : int

func _ready():
	
	var hauteur = randi_range(20, 1060)
	position.y = hauteur
	
	var variation_treshold = randf_range(-1,1)
	max_treshold += variation_treshold
	
	var variation_puissance = randf_range(-5,5)
	puissance_battement += variation_puissance
	
	var variation_init = randf_range(-5,3)
	hvelocite_init += variation_init
	
	var variation_scale = randf_range(0.08, 0.4)
	scale = Vector2(variation_scale, variation_scale)
	
	var gauche_ou_droite = randi_range(0,1)
	if gauche_ou_droite :
		position.x = -90
		deplacement_a_gauche = false
	else :
		position.x = 2000
		deplacement_a_gauche = true
		scale.x = -scale.x
	
	
	if deplacement_a_gauche :
		velocite.x = -hvelocite_init
	else :
		velocite.x = hvelocite_init
	call_deferred("connecter_signal")


func connecter_signal():
	get_parent().random_ticker.timeout.connect(reception_random_tick)

func reception_random_tick():
	last_random_tick = randi_range(0,100)

func appliquer_force(force : Vector2):
	force = force/masse
	acceleration += force

func battement():
	if deplacement_a_gauche :
		appliquer_force(Vector2(-puissance_battement,0))
	else :
		appliquer_force(Vector2(puissance_battement,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if abs(velocite.x) < max_treshold :
		if last_random_tick > 50 :
			battement()
	
	velocite *= 0.97
	
	
	
	velocite += acceleration
	position += velocite
	acceleration *= 0
