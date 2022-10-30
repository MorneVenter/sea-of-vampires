extends Control


func _unfade() -> void:
	Events.emit_signal("unfade")


func _reload() -> void:
	Events.emit_signal("reload")
