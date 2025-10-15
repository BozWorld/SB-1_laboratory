extends AttributPhysique

@export var frottements := 0.05
@export var puissance := 1.0

func prendreInput() -> float:
    var prise_input = Input.get_axis("avancer", "freiner")
    return prise_input

func logiqueMoteur():
    var poussee = parent.transform.basis.z * (prendreInput()  * puissance)
    print(poussee)

    if poussee :
        parent.appliquerForce(poussee)
    
    if parent.velocite :
        parent.appliquerFriction()