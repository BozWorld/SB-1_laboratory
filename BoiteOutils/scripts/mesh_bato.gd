@tool
extends MeshInstance3D

@onready var vergue = %Vergue

func _ready():
	var mesh_donnees = []
	mesh_donnees.resize(ArrayMesh.ARRAY_MAX)
	mesh_donnees[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(
		[
			# haut proue
			Vector3(2.5,0.0,0.0),
			Vector3(1.0,0.0,0.8),
			Vector3(1.0,0.0,-0.8),
			
			#haut poupe
			Vector3(-1.5,0.0,1.0),
			Vector3(-1.5,0.0,-1.0),
			Vector3(-2.0,0.0,0.0),
			
			#bas proue
			Vector3(1.5,-0.8,0.0),
			Vector3(1.0,-0.8,0.7),
			Vector3(1.0,-0.8,-0.7),
			
			#bas poupe
			Vector3(-1.4,-0.8,0.8),
			Vector3(-1.4,-0.8,-0.8)
		]
	)
	
	mesh_donnees[ArrayMesh.ARRAY_INDEX] = PackedInt32Array(
		[
			#pont
			0,1,2,
			2,1,3,
			2,3,4,
			3,5,4,
			
			#proue bas
			0,8,7,
			0,7,1,
			0,2,8,
			
			#facade tribord
			1,7,3,
			3,7,9,
			
			#facade babord
			2,4,8,
			4,10,8,
			
			#facade proue
			3,9,5,
			4,5,10,
			5,9,10,
			
			#fond
			7,8,9,
			8,10,9
		]
	)
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_donnees)
	
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
