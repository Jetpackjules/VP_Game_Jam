extends "res://Cards/Card.gd"

func apply_effect():
	get_parent().player.healthbar.max_value *= 1.5
