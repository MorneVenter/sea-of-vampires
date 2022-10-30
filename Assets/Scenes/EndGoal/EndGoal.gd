extends Spatial

func _on_TriggerArea_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.finish()
