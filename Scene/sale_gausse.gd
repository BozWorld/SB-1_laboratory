extends MeshInstance3D
class_name SaleGausse


@export var origine_orbite : Node3D

var puissance_attraction := 0.05


var velocite := Vector3.ZERO
var acceleration := Vector3.ZERO

func generationVelociteInitiale():
	#var derniere_velocite := Vector3.ZERO
	#for i in range(10) :
		#var velocite_actuelle := Vector3.ZERO
		velocite.x = randf_range(-1.0,1.0)
		velocite.y = randf_range(-1.0,1.0)
		velocite.z = randf_range(-1.0,1.0)
		
		velocite = velocite.normalized() * 8.8

func _ready() -> void:
	generationVelociteInitiale()

func attractionGravitationnelle():
	var distance := origine_orbite.position - position
	
	if distance.length() > 0.0 :
		var attraction := Vector3.ZERO
		
		attraction = distance.normalized()
		attraction *= clamp(1.0/distance.length(), 0.44, 100.0)
		print(1.0/distance.length())
		return attraction

func _physics_process(delta: float) -> void:
	var force_gravitationnelle = attractionGravitationnelle()
	if force_gravitationnelle :
		acceleration += force_gravitationnelle * puissance_attraction
	
	velocite += acceleration
	position += velocite * delta
	acceleration = Vector3.ZERO
