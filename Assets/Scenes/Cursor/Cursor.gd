extends Control

onready var _mouse: Control = $Mouse

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta) -> void:
	_mouse.rect_position = self.get_global_mouse_position()
	_mouse.rect_position = Vector2(round(_mouse.rect_position.x), round(_mouse.rect_position.y))
