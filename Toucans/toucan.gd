extends Sprite2D

@export var masse = 1.0
@export var hvelocite_init : float = 10
@export var deplacement_a_gauche : bool = false
@export var puissance_battement : float = 10
@export var max_treshold : float = 1.5

var velocite : Vector2
var acceleration : Vector2

var last_random_tick : int

func _ready():
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
	
	velocite *= 0.95
	
	
	
	velocite += acceleration
	position += velocite
	acceleration *= 0
