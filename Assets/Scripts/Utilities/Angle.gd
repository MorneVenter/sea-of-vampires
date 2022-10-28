extends Node


func lerp_degrees(from: float, to: float, weight: float) -> float:
	return from + _short_angle_dist(from, to) * weight

func _short_angle_dist(from: float, to: float) -> float:
	var max_angle: float = PI * 2.0
	var difference: float = fmod(to - from, max_angle)
	return fmod(2.0 * difference, max_angle) - difference
