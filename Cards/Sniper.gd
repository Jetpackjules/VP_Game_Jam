extends "res://Cards/Card.gd"


func apply_effect():
	for emitter in get_parent().player.emitters.get_children():
		emitter.proj_dmg *= 1.3
		emitter.set_interval(emitter.firing_interval * 1.3)
