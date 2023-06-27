extends KinematicBody2D

#var speed: float = 0.0
var size: Vector2 = Vector2()
var damage: int = 50
var velocity := Vector2()
var knockback_mult := 1.0


func _process(delta):
	if Global.game_paused:
		return
	move_and_slide(velocity)
	if velocity.length() > 0:
		rotation = velocity.angle() + deg2rad(90)
	else:
		queue_free()
#	print(global_position.length())
	if global_position.length() > 2000:
		queue_free()
	

#func set_speed(new_speed):
#	speed = new_speed

func set_size(new_size):
	size = new_size
	scale = size

func get_damage():
	return damage

func set_velocity(velocity_set) -> void:
	velocity = velocity_set

func set_damage(new_dmg) -> void:
	damage = new_dmg

func _on_Area2D_body_entered(body):
	body.hit(damage, damage*10*knockback_mult)
	queue_free()
	pass # Replace with function body.
