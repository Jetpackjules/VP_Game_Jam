extends Node2D

export var health = 100.0  # Overall health
export var splat_scale = 1.0

var knockback_timer := 0.0  # Timer to reduce knockback effect
var knockback = false


var dead = false  # Whether the character is dead or not
onready var timer: Timer = $Timer
onready var parent = get_parent()
onready var movement = parent.get_node("Navigation")



func hit(damage, knockback_force, cause_velocity):
	flash_white()
	
	health -= damage
	if health <= 0:
		die(knockback_force, cause_velocity)
	else:
		knockback = true
		var knockback_direction = cause_velocity.normalized()
		
		knockback_timer = 0.0625  # Knockback effect lasts for 0.5 seconds
		
		movement.velocity = knockback_direction * knockback_force  # Apply knockback by modifying parent's velocity
#		parent.state = parent.State.KNOCKBACK
		

func die(force, direction):
	dead = true
	Global.splat(global_position, direction, splat_scale)
	parent.queue_free()

func flash_white():
	parent.modulate = Color(100, 100, 100)  # Set color to white
	timer.start(0.18)  # Start timer to revert color after 0.1 seconds

func _on_Timer_timeout():
	parent.modulate =  Color(1, 1, 1)  # Revert color to original



func _process(delta):
	if knockback:
#		movement.speed = 70

		movement.set_target_location(global_position)
		if knockback_timer > -0.25:
			if knockback_timer > 0:
				knockback_timer -= delta
				movement.velocity *=  0.5
				parent.move_and_slide(movement.velocity) 
			else:
				knockback_timer -= delta
				parent.move_and_slide(movement.velocity*(1-abs(knockback_timer)/0.25))
		else:
#			parent.state = parent.State.ATTACKING_PLAYER
			knockback = false
