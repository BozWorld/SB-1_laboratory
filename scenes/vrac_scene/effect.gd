extends MeshInstance3D

@export var camera_path: NodePath
@export var distance := 0.2
@export var padding := 0.02

var cam: Camera3D

func _ready() -> void:
	if camera_path != NodePath(""):
		cam = get_node(camera_path) as Camera3D
	else:
		cam = get_viewport().get_camera_3d()
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	set_as_top_level(true)

func _process(_dt: float) -> void:
	if cam == null:
		return

	var d: float = float(max(distance, cam.near + 0.01))
	global_transform = cam.global_transform
	translate_object_local(Vector3(0, 0, -d))

	var q := mesh as QuadMesh
	if q == null:
		return

	var vp := get_viewport().get_visible_rect().size
	var aspect: float = float(vp.x) / float(max(1.0, float(vp.y)))

	if cam.projection == Camera3D.PROJECTION_PERSPECTIVE:
		var near_h: float = 2.0 * float(tan(cam.fov * 0.5 * PI / 180.0)) * d
		var near_w: float = near_h * aspect
		q.size = Vector2(near_w + padding, near_h + padding)
	else:
		q.size = Vector2(cam.size * aspect + padding, cam.size + padding)
