extends Spatial

export var _collider_path: NodePath

var _collider: CollisionShape

func _ready() -> void:
	_collider = get_node(_collider_path)
	assert(_collider != null, "CollisionShape not found for Rock.")
	_set_collider_off()

func _set_collider_on() -> void:
	_collider.disabled = false

func _set_collider_off() -> void:
	_collider.disabled = true

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		_set_collider_on()

func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		_set_collider_off()
