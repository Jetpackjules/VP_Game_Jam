extends "res://Cards/Card.gd"

func apply_effect():
	get_parent().player.acceleration *= 1.2
