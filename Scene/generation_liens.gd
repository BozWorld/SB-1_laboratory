@tool
extends MeshInstance3D

@onready var corps = get_parent()

var nb_points_avant : int
var nb_points_centraux : int
var nb_points_arriere : int

func _ready():
	creationMeshCorps()

func detruireCorps():
	mesh = null

func creationMeshCorps():
	var mesh_donnees = []
	mesh_donnees.resize(ArrayMesh.ARRAY_MAX)
	mesh_donnees[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	
	# On vient tout d'abord chercher les points de la tête
	nb_points_avant = 0
	for point in corps.vertebres[0].points_avant :
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(point + corps.vertebres[0].position)
		nb_points_avant += 1
	
	# Puis les points des vertebres qui font le long du corps
	nb_points_centraux = 0
	for vertebre in corps.vertebres :
		for point in vertebre.points_centraux :
			mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(point + vertebre.position)
			nb_points_centraux += 1
	
	# Et enfin ceux de la queue
	nb_points_arriere = 0
	for point in corps.vertebres[corps.vertebres.size()-1].points_arriere :
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(point + corps.vertebres[corps.vertebres.size()-1].position)
		nb_points_arriere += 1
	
	
	mesh_donnees[ArrayMesh.ARRAY_INDEX] = PackedInt32Array()
	var index := 1
	
	# On assemble la tête
	while index < nb_points_avant :
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(0)
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index + 1)
		index += 1
	 
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(nb_points_avant - 1)
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(0)
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(1)
	index += 1
	
	var anti_index : int
	
	
	for vertebre in corps.vertebres :
		if vertebre.vertebre_precedente :
			anti_index = index
			for i_point in vertebre.points_centraux.size() -2 :
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index + 1)
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index - vertebre.points_centraux.size())
				index += 1
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index - anti_index)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index - vertebre.points_centraux.size())
			index += 1
			
			
		if vertebre.vertebre_suivante :
			anti_index = index
			for i_point in vertebre.points_centraux.size() -2 :
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index + 1)
				mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index + 1 + vertebre.points_centraux.size())
				index += 1
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index - anti_index)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index - anti_index + vertebre.points_centraux.size())
			index += 1
			
			
	
	anti_index = index
	index += 1
	
	while index - anti_index < nb_points_avant :
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index + 1)
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(anti_index)
		mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index)
		index += 1
	 
	
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(anti_index + 1)
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(0)
	mesh_donnees[ArrayMesh.ARRAY_INDEX].append(anti_index + nb_points_avant - 2)
	
	

	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_donnees)
	
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
