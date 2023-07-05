# MovementModule.gd
extends NavigationAgent2D

onready var navigation = Global.Nav
onready var tile_map = Global.Tilemap_Wall
onready var tile_map_floor = Global.Tilemap_Floor
onready var parent = get_parent()

var speed = 300
var velocity = Vector2.ZERO
var damping = 0.68  # Adjust this value to change the damping effect

func _ready():
	self.set_navigation(navigation)

func set_target_location(target):
	self.set_target_location(target)

func is_navigation_finished():
	return self.is_navigation_finished()

func get_next_location():
	return self.get_next_location()

func set_velocity(new_velocity):
	velocity = new_velocity
	self.set_velocity(velocity)


func _on_velocity_computed(safe_velocity):
	velocity = parent.move_and_slide(safe_velocity)
