extends Spatial

onready var world: Spatial = $World

var blood_sea = preload("res://Assets/Scenes/Levels/BloodSea/BloodSea.tscn")

func _ready() -> void:
	var _err = Events.connect("reload", self, "_reload")
	OS.set_window_maximized(true)

func _reload() -> void:
	for child in world.get_children():
		child.queue_free()
	var new_level = blood_sea.instance()
	world.add_child(new_level)
	Events.emit_signal("unfade")
