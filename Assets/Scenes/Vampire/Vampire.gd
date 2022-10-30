extends MeshInstance

onready var detection_area: Area = $DetectionArea

export var patrol_range: float = 10.0
export var patrol_speed: float = 0.9
export var persue_speed: float = 2.3

const PLAYER_GROUP: String = "Player"
const PERSUE_WAIT_TIME: float = 4.5
const DETECTION_TIME: float = 1.0
const MOMENTUM: float = 0.07

var patrol_points: Array = []
var total_patrol_points: int = 5
var active_patrol_poin: int = 0
var patrol_wait_timer: Timer
var patrol_wait_time: float = 3.0
var persue_object: PlayerBoat
var persue_idle_time: float = 0.0
var current_detection_time: float = 0.0
var current_persue_speed: float = 0.0

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
	if persue_object == null:
		_scan_for_player()
		_move_to_active_point(delta)
	else:
		_persue(delta)

func _scan_for_player() -> void:
	var has_found_player: bool = false
	var bodies := detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group(PLAYER_GROUP) and body.is_moving:
			current_detection_time += 1
			has_found_player = true
			if current_detection_time >= DETECTION_TIME * 60.0:
				current_detection_time = 0
				persue_object = body
				persue_object.add_pursuer(self)
				return
	if not has_found_player:
		current_detection_time = 0

func _init_patrol_points() -> void:
	randomize()
	active_patrol_poin= 0
	patrol_points = []
	for _i in range(total_patrol_points):
		var new_point: Vector3 = Vector3(transform.origin.x + rand_range(-patrol_range, patrol_range), transform.origin.y, transform.origin.z + rand_range(-patrol_range, patrol_range))
		patrol_points.append(new_point)

func _persue(delta: float) -> void:
	if persue_object.is_moving:
		current_persue_speed = clamp(current_persue_speed + MOMENTUM, 0, persue_speed)
		persue_idle_time = 0.0
	else:
		current_persue_speed = clamp(current_persue_speed - MOMENTUM, 0, persue_speed)
		persue_idle_time += 1.0
	transform.origin = transform.origin.move_toward(persue_object.transform.origin, delta * current_persue_speed)
	if persue_idle_time > 60 * PERSUE_WAIT_TIME:
		_init_patrol_points()
		persue_object.remove_pursuer(self)
		persue_object = null

func _next_patrol_point() -> void:
	if active_patrol_poin + 1 >= patrol_points.size():
		active_patrol_poin = 0
	else:
		active_patrol_poin += 1

func _move_to_active_point(delta: float) -> void:
	transform.origin = transform.origin.move_toward(patrol_points[active_patrol_poin], delta * patrol_speed)
	if transform.origin.distance_squared_to( patrol_points[active_patrol_poin]) < 0.1 and patrol_wait_timer.is_stopped():
		patrol_wait_timer.start()

func _on_KillArea_body_entered(body: Node) -> void:
	if body.is_in_group(PLAYER_GROUP):
		body.kill()
