# MovementModule.gd
extends NavigationAgent2D

onready var navigation: Navigation2D = Global.Nav
onready var parent: KinematicBody2D = get_parent()

var active := true
export var speed := 300.0
var velocity := Vector2.ZERO
export var damping := 0.68  # Adjust this value to change the damping effect

var line: Line2D
export var show_path := true

func _ready():
	max_speed = speed
	self.set_navigation(navigation)
	if show_path:
		line = Line2D.new()
		add_child(line)

func _on_Navigation_velocity_computed(safe_velocity):
	if active:
		velocity = parent.move_and_slide(safe_velocity)
		if parent.get("body"):
			parent.body.rotation = lerp_angle(parent.body.rotation, safe_velocity.angle(), 0.25)

func move_to_target(target):
	set_target_location(target)

	if not is_navigation_finished():
#		print(is_target_reachable())
		
		if show_path:
			line.points = get_nav_path()
#		print(line.points)
		var test = get_nav_path()
		var next_location = get_next_location()
		var direction = (next_location - parent.global_position).normalized()
		var velocity = direction * speed
		set_velocity(velocity)
		


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
