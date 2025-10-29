extends Node3D

@export var cible : Node3D

@export_range(0.0,1.0,0.01) var vitesse_deplacement : float = 0.3
@export_range(0.0,1.0,0.01) var vitesse_rotation : float = 0.2

var latence := 0.0


func _physics_process(delta):
	if cible :
		if cible.position != position :
			position = position.slerp(cible.position, vitesse_deplacement)
			latence = (cible.position-position).length()
		if cible.transform.basis != transform.basis :
			var rota = Quaternion(transform.basis.orthonormalized())
			var rota_cible = Quaternion(cible.transform.basis.orthonormalized())

			var nouvelle_rota = rota.slerp(rota_cible, vitesse_rotation)
			transform.basis = Basis(nouvelle_rota)
