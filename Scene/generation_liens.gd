@tool
extends MeshInstance3D

@onready var corps = get_parent()

func _ready():
	creationMeshCorps()

func detruireCorps():
	mesh = null

func creationMeshCorps():
	var mesh_donnees = []
	mesh_donnees.resize(ArrayMesh.ARRAY_MAX)
	mesh_donnees[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	for vertebre in corps.vertebres :
		
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.haut * vertebre.post_distance)
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.gauche * vertebre.post_distance)
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.bas * vertebre.post_distance)
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.droite * vertebre.post_distance)
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.avant * vertebre.post_distance)
		mesh_donnees[ArrayMesh.ARRAY_VERTEX].append(vertebre.position + vertebre.arriere * vertebre.post_distance)
		
		
	mesh_donnees[ArrayMesh.ARRAY_INDEX] = PackedInt32Array()
	var index := 0
	for vertebre in corps.vertebres:
		if vertebre.vertebre_suivante :
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 6)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 6+1)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 6+2)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index+1) * 6+3)
		
		else :
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 5)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 1)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 5)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 2)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 5)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 5)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 3)
		
		
		if vertebre.vertebre_precedente :
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 6+1)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 6+2)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 6+3)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6+3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append((index-1) * 6)
		else :
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 4)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 1)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 4)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 1)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 2)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 4)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 3)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6)
			
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 4)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 2)
			mesh_donnees[ArrayMesh.ARRAY_INDEX].append(index * 6 + 3)
			
		index += 1
	
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_donnees)
	
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
