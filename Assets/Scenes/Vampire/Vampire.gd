extends MeshInstance

export var patrol_range: float = 10.0
export var patrol_speed: float = 0.9

var patrol_points: Array = []
var total_patrol_points: int = 5
var active_patrol_poin: int = 0
var patrol_wait_timer: Timer
var patrol_wait_time: float = 3.0

func _ready() -> void:
	patrol_wait_timer = Timer.new()
	patrol_wait_timer.one_shot = true
	patrol_wait_timer.autostart = false
	patrol_wait_timer.wait_time = patrol_wait_time
	add_child(patrol_wait_timer)
	var _error = patrol_wait_timer.connect("timeout", self, "_next_patrol_point")
	if patrol_points.size() <= 0:
		_init_patrol_points()

func _physics_process(delta: float) -> void:
	_move_to_active_point(delta)

func _init_patrol_points() -> void:
	randomize()
	patrol_points = []
	for _i in range(total_patrol_points):
		var new_point: Vector3 = Vector3(transform.origin.x + rand_range(-patrol_range, patrol_range), transform.origin.y, transform.origin.z + rand_range(-patrol_range, patrol_range))
		patrol_points.append(new_point)

func _next_patrol_point() -> void:
	if active_patrol_poin + 1 >= patrol_points.size():
		active_patrol_poin = 0
	else:
		active_patrol_poin += 1

func _move_to_active_point(delta: float) -> void:
	transform.origin = transform.origin.move_toward(patrol_points[active_patrol_poin], delta * patrol_speed)
	if transform.origin.distance_squared_to( patrol_points[active_patrol_poin]) < 0.1 and patrol_wait_timer.is_stopped():
		patrol_wait_timer.start()
