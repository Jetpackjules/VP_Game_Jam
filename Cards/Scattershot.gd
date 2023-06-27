extends "res://Cards/Card.gd"


func apply_effect():
	for emitter in get_parent().player.emitters.get_children():
		emitter.spread *= 1.15
		emitter.amount_emitted += 1
