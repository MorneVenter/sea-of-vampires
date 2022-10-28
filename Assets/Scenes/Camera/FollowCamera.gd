extends Camera

export var target_node: NodePath
export var follow_speed: float = 3.0

var target: Spatial
var position_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	_check_if_target_node_exists()
	_set_camera_offset()
	translation = _get_targeted_position()

func _physics_process(delta):
	_check_if_target_node_exists()
	transform.origin = lerp(transform.origin, _get_targeted_position(), follow_speed * delta)


func _set_camera_offset() -> void:
	position_offset = transform.origin - target.transform.origin

func _check_if_target_node_exists() -> void:
	if target_node == null or target == null:
		target = get_node(target_node)
		assert(target_node != null and target != null, "\"follow_camera\" could not find the node to follow. Insure that it has been asigned on the camera.")

func _get_targeted_position() -> Vector3:
	_check_if_target_node_exists()
	var global_target_position: Vector3 = target.transform.origin
	return global_target_position + position_offset

