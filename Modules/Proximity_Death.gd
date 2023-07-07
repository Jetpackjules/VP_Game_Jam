extends Area2D

export var collision_damage = 10.0
export var collision_knockback = 1500.0
export var collision_self_damage = 50.0



func _on_Proximity_Death_body_entered(body):
	if body.has_node("Health"):
		body.get_node("Health").hit(collision_damage, collision_knockback, body.global_position-global_position)
	if get_parent().has_node("Health"):
#		reduce health...
		pass