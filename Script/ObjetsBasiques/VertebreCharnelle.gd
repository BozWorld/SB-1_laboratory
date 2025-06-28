@tool
extends Vertebre
class_name VertebreCharnelle

var haut := Vector3.ZERO
var bas := Vector3.ZERO
var gauche := Vector3.ZERO
var droite := Vector3.ZERO
var avant := Vector3.ZERO
var arriere := Vector3.ZERO

var mesh_liaison = MeshInstance3D.new()

@onready var corps = get_parent()

@export_range(0, 10, 1,"or_greater") var nb_intersections := 1
var points_centraux : Array[Vector3]
var points_avant : Array[Vector3]
var points_arriere : Array[Vector3]

var genere_centre = false
var genere_avant = false
var genere_arriere = false

func initialisation():
	super()
	actualisationPoints()
	#creationMeshCorps()
	
	

func actualisation(delta):
	super(delta)
	actualisationPoints()
	#creationMeshCorps()

func actualisationPoints():
	haut = global_transform.basis.y
	bas = -global_transform.basis.y
	gauche = -global_transform.basis.x
	droite = global_transform.basis.x
	avant = -global_transform.basis.z
	arriere = global_transform.basis.z
	
	var index_intersections : int
	var cran : Vector3
	
	if genere_centre :
		points_centraux = []
		
		points_centraux.append(haut)
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (gauche-haut) / nb_intersections
			points_centraux.append((haut + cran * index_intersections).normalized()*post_distance)
		
		points_centraux.append(gauche)
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (bas-gauche) / nb_intersections
			points_centraux.append((gauche + cran * index_intersections).normalized()*post_distance)
		
		points_centraux.append(bas)
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (droite-bas) / nb_intersections
			points_centraux.append((bas + cran * index_intersections).normalized()*post_distance)
		
		points_centraux.append(droite)
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (haut-droite) / nb_intersections
			points_centraux.append((droite + cran * index_intersections).normalized()*post_distance)
	
	if genere_avant :
		points_avant = []
		points_avant.append(avant)
		
		points_avant.append(haut)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (haut-avant) / nb_intersections
			points_centraux.append((avant + cran * index_intersections).normalized()*post_distance)
		
		points_avant.append(gauche)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (gauche-avant) / nb_intersections
			points_centraux.append((avant + cran * index_intersections).normalized()*post_distance)
		
		points_avant.append(bas)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (bas-avant) / nb_intersections
			points_centraux.append((avant + cran * index_intersections).normalized()*post_distance)
		
		points_avant.append(droite)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (droite-avant) / nb_intersections
			points_centraux.append((avant + cran * index_intersections).normalized()*post_distance)
	
	if genere_arriere :
		points_arriere = []
		points_arriere.append(arriere)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (haut-arriere) / nb_intersections
			points_centraux.append((arriere + cran * index_intersections).normalized()*post_distance)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (gauche-arriere) / nb_intersections
			points_centraux.append((arriere + cran * index_intersections).normalized()*post_distance)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (bas-arriere) / nb_intersections
			points_centraux.append((arriere + cran * index_intersections).normalized()*post_distance)
		
		index_intersections = 0
		while index_intersections < nb_intersections :
			index_intersections += 1
			cran = (droite-arriere) / nb_intersections
			points_centraux.append((arriere + cran * index_intersections).normalized()*post_distance)

#func actualisationMeshCorps():
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(0, haut * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(1, bas * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(2, gauche * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(3, droite * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(4, avant * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(5, arriere * post_distance)
	#
	#
	#if vertebre_suivante :
		#var distance_vertebre_s
		#distance_vertebre_s = vertebre_suivante.position - position
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(6, vertebre_suivante.haut * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(7, vertebre_suivante.bas * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(8, vertebre_suivante.gauche * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(9, vertebre_suivante.droite * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(10, vertebre_suivante.avant * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(11, vertebre_suivante.arriere * vertebre_suivante.post_distance + distance_vertebre_s)
		#
	#else :
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(6, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(7, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(8, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(9, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(10, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(11, Vector3.ZERO)
	#
	#if vertebre_precedente :
		#var distance_vertebre_p
		#distance_vertebre_p = vertebre_precedente.position - position
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(12, vertebre_precedente.haut * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(13, vertebre_precedente.bas * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(14, vertebre_precedente.gauche * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(15, vertebre_precedente.droite * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(16, vertebre_precedente.avant * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(17, vertebre_precedente.arriere * vertebre_precedente.post_distance + distance_vertebre_p)
		#
	#else :
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(12, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(13, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(14, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(15, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(16, Vector3.ZERO)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].set(17, Vector3.ZERO)
	#
	#
	#
	#
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_donnees)
	#
	#
	#var surface_tool = SurfaceTool.new()
	#surface_tool.create_from(mesh, 0)
	#surface_tool.generate_normals()
	#mesh = surface_tool.commit()
		
#
#func creationMeshCorps():
	#var mesh_donnees = []
	#mesh_donnees.resize(ArrayMesh.ARRAY_MAX)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	#
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(haut * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(bas * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(gauche * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(droite * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(avant * post_distance)
	#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(arriere * post_distance)
	#
	#
	#if vertebre_suivante :
		#var distance_vertebre_s
		#distance_vertebre_s = vertebre_suivante.position - position
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.haut * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.bas * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.gauche * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.droite * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.avant * vertebre_suivante.post_distance + distance_vertebre_s)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_suivante.arriere * vertebre_suivante.post_distance + distance_vertebre_s)
		#
	#else :
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
	#
	#if vertebre_precedente :
		#var distance_vertebre_p
		#distance_vertebre_p = vertebre_precedente.position - position
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.haut * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.bas * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.gauche * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.droite * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.avant * vertebre_precedente.post_distance + distance_vertebre_p)
		#mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre_precedente.arriere * vertebre_precedente.post_distance + distance_vertebre_p)
		#
	#else :
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#mesh_donnees.append(Vector3.ZERO)
		#
	#
	#mesh_donnees[ArrayMesh.ARRAY_INDEX] = PackedInt32Array()
	#var index := 0
	#for vertebre in corps.vertebres:
		#if vertebre.vertebre_suivante :
			#mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4)
			#mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+1)
			#mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 4)
			#
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+1)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+2)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 4+1)
			#
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+2)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+3)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 4+2)
			##
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+3)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 4+3)
		##
		##if vertebre.vertebre_precedente :
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+1)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 4+1)
			##
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+1)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+2)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 4+2)
			##
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+2)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+3)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 4+3)
			##
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 4+3)
			##mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 4)
			#
		#index += 1
	#
	#mesh = ArrayMesh.new()
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_donnees)
	#
	#
	#var surface_tool = SurfaceTool.new()
	#surface_tool.create_from(mesh, 0)
	#surface_tool.generate_normals()
	#mesh = surface_tool.commit()

func prendrePointsCentraux():
	actualisationPoints()
	if genere_centre :
		return points_centraux

func prendrePointsAvant():
	actualisationPoints()
	if genere_avant :
		return points_avant

func prendrePointsArriere():
	actualisationPoints()
	if genere_arriere :
		return points_arriere
