# MovementModule.gd
extends NavigationAgent2D

onready var navigation = Global.Nav
onready var parent = get_parent()

var speed = 300
var velocity = Vector2.ZERO
var damping = 0.68  # Adjust this value to change the damping effect

func _ready():
	self.set_navigation(navigation)

func _on_Navigation_velocity_computed(safe_velocity):
	velocity = parent.move_and_slide(safe_velocity)
