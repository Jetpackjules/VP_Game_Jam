extends "res://Cards/Card.gd"


func apply_effect():
	get_parent().player.heal_percent += 1
	get_parent().player.healthbar.max_value *= 0.8
	pass
