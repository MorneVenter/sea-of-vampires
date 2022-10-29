extends KinematicBody

onready var _boat_light: OmniLight = $BoatMesh/BoatLight
onready var _engine_sound: AudioStreamPlayer3D = $EngineSound

export var max_speed: float = 2.6
export var momentum: float = 0.03
export var rotation_speed: float = 0.005
export var turn_speed: float = 0.02

var speed: float = 0.0
var move_direction: Vector3 = Vector3.ZERO
var dead_zone: float = 2.0
var light_energy: float = 1.0

func _ready() -> void:
	_boat_light.light_energy = 0.0
	_engine_sound.unit_db = -80.0

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
	var _velocity := move_and_slide(move_direction.normalized() * speed)
	var _speed_factor: float = speed / max_speed
	_boat_light.light_energy = _speed_factor * light_energy
	_engine_sound.unit_db = (_speed_factor * 40.0 - 40.0) if _speed_factor > 0.0 else -80.0
	transform.origin.y = lerp(transform.origin.y, 0.0, 0.6)

func _reduce_speed() -> void:
	speed = clamp(speed - momentum, 0, max_speed)

func _increase_speed() -> void:
	speed = clamp(speed + momentum, 0, max_speed)

func _move(position_of_mouse: Vector3) -> void:
	var target_vector: Vector3 = (transform.origin - position_of_mouse)
	var target_rotation: float = atan2(target_vector.x, target_vector.z)
	rotation.y = Angle.lerp_degrees(rotation.y, target_rotation, rotation_speed)
	var new_direction := Vector3(-target_vector.x, 0, -target_vector.z).normalized()
	move_direction = lerp(move_direction, new_direction, turn_speed)

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
