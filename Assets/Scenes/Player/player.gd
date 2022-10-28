extends KinematicBody

onready var _boat_mesh: Spatial = $BoatMesh

export var max_speed: float = 3.0
export var momentum: float = 0.03
export var rotation_speed: float = 0.04

var speed: float = 0.0
var move_direction: Vector3 = Vector3.ZERO
var dead_zone: float = 2.0

func _physics_process(_delta: float) -> void:
	_handle_movement()

func _handle_movement() -> void:
	if Input.is_action_pressed("left_click"):
		var position_of_mouse: Vector3 = _get_mouse_position()
		if transform.origin.distance_to(position_of_mouse) <= dead_zone:
			_reduce_speed()
		else:
			_increase_speed()
			_move(position_of_mouse)
	else:
		_reduce_speed()
	var _velocity := move_and_slide(move_direction * speed)

func _reduce_speed() -> void:
	speed = clamp(speed - momentum, 0, max_speed)

func _increase_speed() -> void:
	speed = clamp(speed + momentum, 0, max_speed)

func _move(position_of_mouse: Vector3) -> void:
	var target_vector: Vector3 = (transform.origin - position_of_mouse)
	var target_rotation: float = atan2(target_vector.x, target_vector.z)
	rotation.y = Angle.lerp_degrees(rotation.y, target_rotation, rotation_speed)
	move_direction = Vector3(-target_vector.x, 0, -target_vector.z).normalized()

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
