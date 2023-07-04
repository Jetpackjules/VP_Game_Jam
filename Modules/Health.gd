extends Node2D

export var health = 100.0  # Overall health
export var knockback_force = 10.0  # Knockback amount
export var splat_scale = 1.0


var dead = false  # Whether the character is dead or not

# Assuming you have an AnimationPlayer node named "hit_anim"
onready var hit_anim = $hit_anim\

func hit(damage, knockback_force, cause):
	# hit_anim.play("Hit")
	health -= damage
	if health <= 0:
		die(knockback_force, cause.velocity)
	else:
		var knockback_direction = cause.velocity.normalized()
		var parent_body = get_parent()
		if parent_body is KinematicBody2D:
			parent_body.velocity += knockback_direction * knockback_force


func die(force, direction):
	dead = true
	Global.splat(global_position, direction, splat_scale)
	get_parent().queue_free()

