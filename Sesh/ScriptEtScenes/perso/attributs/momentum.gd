extends Attribut3D

var h_momentum := 0.0
var v_momentum := 0.0

var h_momentum_stored := false
var v_momentum_stored := false

var h_delta := 0.0
var v_delta := 0.0

var duree_amorti := 0.4

var seuil_min := 0.4

func store_momentum(momentum : Vector3):
	if abs(momentum.y) > seuil_min and abs(momentum.y) >= v_momentum:
		v_momentum = abs(momentum.y)
		v_momentum_stored = true
		v_delta = 0.0
		print("Nouveau momentum vertical enregistré !
		Puissance : " + str(v_momentum))
	
	momentum.y = 0.0
	
	if momentum.length() > seuil_min and momentum.length() >= h_momentum:
		h_momentum = momentum.length()
		h_momentum_stored = true
		h_delta = 0.0
		print("Nouveau momentum horizontal enregistré !
		Puissance : " + str(h_momentum))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if v_momentum_stored :
		v_delta += delta
		if v_delta > duree_amorti :
			v_momentum -= delta * (44.4/(v_momentum))
			if v_momentum >= seuil_min :
				v_momentum = 0.0
				v_momentum_stored = false
	
	if h_momentum_stored :
		h_delta += delta
		if h_delta > duree_amorti :
			h_momentum -= delta * (10.0/(h_momentum))
			if h_momentum < seuil_min :
				h_momentum = 0.0
				h_momentum_stored = false

func _liberer_v_momentum():
	if v_delta < duree_amorti :
		v_momentum = 0.0
		
	var puissance := v_momentum
	v_momentum = 0.0
	v_momentum_stored = false
	v_delta = 0.0
	
	return puissance

func _liberer_h_momentum():
	if h_delta < duree_amorti :
		print("Faux départ !
		Boost perdu : " + str(h_momentum))
		h_momentum = 0.0
	
	var puissance := h_momentum
	h_momentum = 0.0
	h_momentum_stored = false
	h_delta = 0.0
	
	return puissance
