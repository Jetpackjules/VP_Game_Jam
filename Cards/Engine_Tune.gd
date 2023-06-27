extends "res://Cards/Card.gd"


func apply_effect():
	get_parent().player.max_speed *= 1.5
