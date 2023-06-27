extends "res://Cards/Card.gd"


func apply_effect():
	get_parent().player.rotation_speed *= 1.3
	for emitter in get_parent().player.emitters.get_children():
		emitter.amount_emitted *= 2
		emitter.proj_dmg *= 0.2
		emitter.set_interval(emitter.firing_interval * 0.5)
