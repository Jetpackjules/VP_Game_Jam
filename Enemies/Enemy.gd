extends RigidBody2D

export var speed = 20
export var health = 100.0
var player = null
var original_linear_velocity = Vector2.ZERO
var original_angular_velocity = 0
onready var hit_anim = get_node("Hit_Anim")
var dead := false
#onready var sprite = get_node("Icon")
var max_speed := 200



func _physics_process(delta):
#	queue_free()
	if Global.game_paused and mode != MODE_STATIC or dead:
		original_linear_velocity = linear_velocity
		original_angular_velocity = angular_velocity
		mode = MODE_STATIC
	elif !Global.game_paused and !dead:
		if mode == MODE_STATIC:
			linear_velocity = original_linear_velocity
			angular_velocity = original_angular_velocity
			mode = MODE_RIGID


		var direction = Vector2.ZERO
		if player != null:
			direction = (player.global_position - global_position).normalized()
			self.look_at(player.global_position)  # Make the enemy face the player
		apply_central_impulse(direction * speed)
		# Capping the maximum speed
		if linear_velocity.length() > max_speed:
			linear_velocity = linear_velocity.normalized() * max_speed

func hit(damage, knockback_force, cause):
	hit_anim.play("Hit")
	health -= damage
#	if health <= 0:
	die(knockback_force, cause.velocity)
#	else:
#		pass
#		var knockback_direction = cause.velocity
##		(global_position - player.global_position).normalized()
#		apply_impulse(Vector2.ZERO, knockback_direction * knockback_force)


func die(force, direction):
	dead = true
	get_parent().get_parent().get_node("Score").increase_score(10)
	Global.splat(global_position, direction)
	queue_free()

func _on_Basic_body_entered(body):
	if body == player:
		player.hit(10, global_position)
		die(0, (global_position - player.global_position))
	pass # Replace with function body.

