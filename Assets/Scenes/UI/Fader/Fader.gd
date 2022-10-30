extends Control

onready var _black: TextureRect = $Background

var _modulate_target: float = 0.0

func _ready() -> void:
	_black.modulate.a = 1.0
	_unfade()
	var _err_fade = Events.connect("fade", self, "_fade_to_black")
	var _err_unfade = Events.connect("unfade", self, "_unfade")

func _process(_delta: float) -> void:
	_black.modulate.a = lerp(_black.modulate.a, _modulate_target, 0.05)

func _fade_to_black() -> void:
	_modulate_target = 1.0

func _unfade() -> void:
	_modulate_target = 0.0
