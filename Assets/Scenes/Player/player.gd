extends KinematicBody

onready var _boat_mesh: Spatial = $BoatMesh

func _physics_process(delta: float) -> void:
	_move(delta)


func _move(delta) -> void:
	var position_of_mouse: Vector3 = _get_mouse_position()
	transform.origin = lerp(transform.origin, position_of_mouse, 0.01)
	var target_vector: Vector3 = (transform.origin - position_of_mouse)
	var target_rotation: float = atan2(target_vector.x, target_vector.z)
	rotation.y = Angle.lerp_degrees(rotation.y, target_rotation, 0.03)


func _get_mouse_position() -> Vector3:
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera()

	var ray_start = camera.project_ray_origin(mouse_position)
	var ray_end = ray_start + camera.project_ray_normal(mouse_position) * 2000.0
	var ray_list = space_state.intersect_ray(ray_start, ray_end, [], 2)
	if ray_list.has("position") and ray_list["collider"].is_in_group("Sea"):
		return ray_list["position"]
	return Vector3.ZERO
