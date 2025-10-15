extends AttributPhysique

var rotacceleration := Vector3.ZERO
var rotacite := Vector3.ZERO
var rota := Vector3.ZERO

@export var puissance := 0.5

@export var frottements := 0.1

@export var pen := 1.0

func effectuerRotation():
    rotacite += rotacceleration
    rotacceleration *= 0.0
    rota += rotacite

    parent.transform.basis = Basis()

    parent.rotate_object_local(Vector3(0,1,0), rota.y)
    parent.rotate_object_local(Vector3(1,0,0), rota.x)
    parent.rotate_object_local(Vector3(0,0,1), rota.z)

func appliquerRotation(rotation : Vector3):
    rotacceleration += rotation * pen

func prendreInput() -> Vector3:
    var prise_input := Vector3()
    prise_input.x = Input.get_axis("rota_bas","rota_haut")
    prise_input.y = Input.get_axis("rota_merde","rota_gauche")
    prise_input.z = Input.get_axis("rota_tmerde","rota_tgauche")

    return prise_input

func appliquerFrottements():
    rotacite *= 1.0 - frottements


func logiqueMoteur(delta : float):
    var pivot = prendreInput() * delta * puissance

    if pivot :
        appliquerRotation(pivot)
    
    effectuerRotation()
    appliquerFrottements()
