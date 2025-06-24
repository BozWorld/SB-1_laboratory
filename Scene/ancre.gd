extends Vertebre

func tenirVerterbreSuivante():
	var distance_vertebre = vertebre_suivante.global_position - global_position
	if distance_vertebre.length() != post_distance :
		vertebre_suivante.global_position = global_position + distance_vertebre.normalized() * post_distance


func _ready() -> void:
	super()
	
	mesh.mesh.material = StandardMaterial3D.new()

func _physics_process(delta: float) -> void:
	tenirVerterbreSuivante()
	
