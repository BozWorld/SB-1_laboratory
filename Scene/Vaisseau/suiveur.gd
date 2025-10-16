extends Node3D

@export var cible : Node3D

@export_range(0.0,100.0,0.1) var vitesse_deplacement : float = 10.0
@export_range(0.0,100.0,0.1) var vitesse_rotation : float = 0.2


func _physics_process(delta):
    if cible :
        if cible.position != position :
            position += (cible.position - position) * vitesse_deplacement * delta
        if cible.transform.basis != transform.basis :
            var rota = Quaternion(transform.basis)
            var rota_cible = Quaternion(cible.transform.basis)

            var nouvelle_rota = rota.slerp(rota_cible, vitesse_rotation)
            transform.basis = Basis(nouvelle_rota)