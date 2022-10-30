extends Control

onready var _text: RichTextLabel = $Text

const TEMPLATE: String = "[color=grey]Current[/color]	[color=red]x: %d[/color], [color=green]y: %d[/color]\n[color=grey]Target[/color] [color=red]x: %d[/color], [color=green]y: %d[/color]"

func _process(_delta: float) -> void:
	var the_player: PlayerBoat = get_tree().get_root().find_node("Player", true, false)
	var end_goal: Spatial = get_tree().get_root().find_node("EndGoal", true, false)
	if the_player != null and end_goal != null:
		var player_position: Vector3 = the_player.transform.origin
		var end_goal_position: Vector3 = end_goal.transform.origin
		_text.bbcode_text = TEMPLATE % [player_position.x, player_position.z * -1, end_goal_position.x, end_goal_position.z * -1]
