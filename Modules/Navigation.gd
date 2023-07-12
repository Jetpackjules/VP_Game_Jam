# MovementModule.gd
extends NavigationAgent2D

onready var navigation: Navigation2D = Global.Nav
onready var parent: KinematicBody2D = get_parent()

var active := true
export var speed := 300.0
var velocity := Vector2.ZERO
export var damping := 0.68  # Adjust this value to change the damping effect

func _ready():
	max_speed = speed
	self.set_navigation(navigation)

func _on_Navigation_velocity_computed(safe_velocity):
	if active:
		velocity = parent.move_and_slide(safe_velocity)
		if parent.get("body"):
			parent.body.rotation = lerp_angle(parent.body.rotation, safe_velocity.angle(), 0.25)

func move_to_target(target):
	set_target_location(target)
	if not is_navigation_finished():
		

		
		var next_location = get_next_location()
		var direction = (next_location - parent.global_position).normalized()
		var velocity = direction * speed
		set_velocity(velocity)
		
		
#		if parent.get("body"):
#			var target_rotation = direction.angle()
#			var current_rotation = parent.body.rotation
#			var smooth_rotation = lerp(current_rotation, target_rotation, 0.1) # Change 0.1 to adjust the speed of rotation
#			parent.body.rotation = smooth_rotation



func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
