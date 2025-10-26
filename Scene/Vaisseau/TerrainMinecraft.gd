@tool
extends MeshInstance3D
class_name TerrainMinecraft

var generateur : Node3D 

# Taille du terrain généré
var taille := 512.0

var resolution := 32

# Fonction qui actualise le mesh du terrain généré
func genererMesh():
	# On prend un énoooooorme plane qu'on divise selon la résolution demandée
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(taille, taille)
	
	# On se prépare a modifier les formes des sous planes, leurs normales et tangeantes
	var plane_arrays := plane.get_mesh_arrays()
	var vertex_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	var tang_array: PackedFloat32Array = plane_arrays[ArrayMesh.ARRAY_TANGENT]
	
	# On vient donc définir selon le bruit tout cela pour chacun des planes du terrain
	for i:int in vertex_array.size():
		var vertex := vertex_array[i]
		var normal := Vector3.UP
		var tangent := Vector3.RIGHT
		if generateur.multi_bruit:
			vertex.y = generateur.prendreHauteur(position.x + vertex.x, position.z + vertex.z)
			normal = generateur.prendreNormale(position.x + vertex.x, position.z + vertex.z)
			tangent = normal.cross(Vector3.UP)
		vertex_array[i] = vertex
		normal_array[i] = normal
		
		# Ta gueule c'est la magie des tangeantes
		tang_array[4 * i] = tangent.x
		tang_array[4 * i + 1] = tangent.y
		tang_array[4 * i + 2] = tangent.z
	
	# On créé un mesh avec toutes les infos définies juste avant
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	mesh = array_mesh
