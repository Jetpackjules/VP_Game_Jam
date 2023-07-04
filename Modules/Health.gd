extends Node2D

export var health = 100.0  # Overall health
export var splat_scale = 1.0


var dead = false  # Whether the character is dead or not


func hit(damage, knockback_force, cause):
	health -= damage
	if health <= 0:
		die(knockback_force, cause.velocity)
	else:
		var knockback_direction = cause.velocity.normalized()
		
		get_parent().knockback_timer = .5  # Knockback effect lasts for 0.5 seconds
		get_parent().velocity += knockback_direction * knockback_force  # Apply knockback by modifying parent's velocity
		get_parent().state = get_parent().State.KNOCKBACK
		



func die(force, direction):
	dead = true
	Global.splat(global_position, direction, splat_scale)
	get_parent().queue_free()

