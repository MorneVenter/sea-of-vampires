extends Control

func _ready() -> void:
	visible = false
	Events.connect("end", self, "_show")

func _show() -> void:
	visible = true
	$Timer.start()

func _on_Timer_timeout() -> void:
	visible = false
	Events.emit_signal("reload")
