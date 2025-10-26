@tool
extends Node3D

# Taille de chaque chunk généré
const taille_chunk := 256.0

@export var couche_chunk := 2 :
	set(nouvelle_couche):
		couche_chunk = nouvelle_couche
		rechargementGenEditeur()

@export var distance_rafraichir := 1

@export var genere_continue := false

var liste_chunk =  {}

## A quel point le terrain généré est précis par rapport au bruit
@export_range(4, 512, 4) var resolution := 32:
	set(nouvelle_res):
		resolution = nouvelle_res
		rechargementGenEditeur()

@export_tool_button("Générer Terrain", "AspectRatioContainer") var invocation_monde = rechargementGenEditeur


## Multi-bruit sur lequel la génération du terrain se base
@export var multi_bruit : MultiBruit:
	set(nouveau_bruit):
		multi_bruit = nouveau_bruit
		rechargementGenEditeur()
		if multi_bruit:
			multi_bruit.changed.connect(rechargementGenEditeur)

## Bruit sur lequel la génération du terrain se base
#@export var bruit : FastNoiseLite:
	#set(nouveau_bruit):
		#bruit = nouveau_bruit
		#rechargementGenEditeur()
		#if bruit:
			#bruit.changed.connect(rechargementGenEditeur)

## Echelle de la hauteur du terrain généré
@export_range(4.0, 128.0, 4.0) var hauteur := 32.0:
	set(nouvelle_hauteur):
		hauteur = nouvelle_hauteur
		material_terrain.set_shader_parameter("hauteur",  hauteur * 2.0)
		rechargementGenEditeur()

## En cas de regen dynamique, est le centre de base horizontalement de la génération
@export var cible_generation : Node3D

@export var seuil_rafraichir := 10.0

@export var material_terrain : ShaderMaterial:
	set(nouveau_material):
		material_terrain = nouveau_material
		rechargementGenEditeur()
		


var index_position := Vector2(0,0)
var index := 0.0

func _ready() -> void:
	rechargementGenEditeur()

# Fonction qui retourne la hauteur du sol selon des coordonées données
func prendreHauteur(x: float, y: float) -> float:
	return multi_bruit.prendreBruit2D(x, y) * hauteur

# Fonction qui retourne un point à la surface selon un point sur le plan horizontal (2D)
func prendrePointSurface(x: float, y: float) -> Vector3:
	var point := Vector3()
	point.y = multi_bruit.prendreBruit2D(x, y) * hauteur
	point.x = x
	point.z = y
	return point

# Fonction qui retourne la normale du sol selon des coordonnées données
func prendreNormale(x: float, y: float) -> Vector3:
	var epsilon := taille_chunk / resolution
	var normal := Vector3(
		(prendreHauteur(position.x + x + epsilon, position.z + y) - prendreHauteur(position.x + x - epsilon, position.z + y)) / (2.0 * epsilon),
		1.0,
		(prendreHauteur(position.x + x, position.z + y + epsilon) - prendreHauteur(position.x + x, position.z + y - epsilon)) / (2.0 * epsilon)
	)
	return normal.normalized()

# Fonction à appeler pour rafraichir la gen autour d'un certain point donné,
# ou sinon depuis la cible définie en export
#func rafraichirGen(centre := Vector3.ZERO ):
	#if centre == Vector3.ZERO :
		#global_position = cible_generation.global_position
		#position.y = 0.0
	#else :
		#position = centre
	##actualiserGen()

func actualiserListe():
	var x = index_position.x
	var y = index_position.y
	
	var temp = []
	
	for chunk in liste_chunk :
		temp.append(chunk)
		
	for i in range(x - couche_chunk, x + couche_chunk + 1):
		for j in range(y - couche_chunk, y + couche_chunk + 1):
			var position_chunk = Vector2(i, j)
			if liste_chunk.find_key(position_chunk):
				temp.erase([position_chunk])
			else :
				var mesh := TerrainMinecraft.new()
				mesh.resolution = resolution
				mesh.taille = taille_chunk
				mesh.material_override = material_terrain
				mesh.position = Vector3(i * taille_chunk, 0.0, j * taille_chunk)
				mesh.generateur = self
				add_child(mesh)
				
				var nouveau := true
				var dico_chunk = {0 : mesh, 1 : nouveau}
				liste_chunk.set(position_chunk, dico_chunk)
	
	for chunk in temp :
		liste_chunk[chunk][0].queue_free()
		liste_chunk.erase(chunk)

func actualiserGen():
	for chunk in liste_chunk :
		if liste_chunk[chunk][1] :
			liste_chunk[chunk][0].genererMesh()

func destructionCrouteTerrestre():
	for chunk in liste_chunk:
		liste_chunk[chunk][0].queue_free()
	liste_chunk.clear()

func rechargementGenEditeur():
	destructionCrouteTerrestre()
	actualiserListe()
	actualiserGen()
	for chunk in liste_chunk :
		liste_chunk[chunk][0].material_override = material_terrain

func _physics_process(delta: float) -> void:
	if genere_continue:
		index += delta
		if index >= seuil_rafraichir :
			var distance_cible = Vector2()
			distance_cible.x = cible_generation.position.x - index_position.x * taille_chunk
			distance_cible.y = cible_generation.position.z - index_position.y * taille_chunk
			if distance_cible.length() > distance_rafraichir * taille_chunk :
				index_position.x = roundi(cible_generation.position.x / taille_chunk)
				index_position.y = roundi(cible_generation.position.z / taille_chunk)
				index = 0.0
				actualiserListe()
				actualiserGen()
