extends "res://Cards/Card.gd"


func apply_effect():
	for emitter in get_parent().player.emitters.get_children():
		emitter.proj_dmg *= 2
		emitter.set_interval(emitter.firing_interval * 2)
