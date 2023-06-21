extends KinematicBody2D

export var speed = 50
var player = null

func _ready():
	player = get_node("/root/Main/Player")  # Update with your player node's path

func _physics_process(delta):
	var direction = Vector2.ZERO
	if player != null:
		direction = (player.global_position - global_position).normalized()
	move_and_slide(direction * speed)
