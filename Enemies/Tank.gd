# Enemy.gd
extends KinematicBody2D

onready var movement_module = $Navigation


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var target_position = get_global_mouse_position()
		movement_module.set_target_location(target_position)
		print(target_position)

func _physics_process(delta):
	if not movement_module.is_navigation_finished():
		var next_location = movement_module.get_next_location()
		var direction = (next_location - global_position).normalized()
		var velocity = direction * movement_module.speed
		movement_module.set_velocity(velocity)
