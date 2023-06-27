extends "res://Cards/Card.gd"


func apply_effect():
	get_parent().player.rotation_speed *= 1.3
	get_parent().player.acceleration *= 0.9
