extends KinematicBody2D

var speed: float = 2000.0  # Increased speed of the bouncer
var bounce_intensity: float = 1.0  # Increased intensity of the bounce when hitting a wall
var player_trend_intensity: float = 0.1  # Intensity of the trend towards the player

onready var player: Node = Global.player  # Reference to the player node

var velocity: Vector2 = Vector2()  # Current velocity of the bouncer

func _physics_process(delta: float) -> void:
#	speed = 3500
	var direction_to_player: Vector2 = (player.global_position - global_position).normalized()
	velocity += direction_to_player * player_trend_intensity * speed * delta

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal) * bounce_intensity

	# Ensure the bouncer's speed does not exceed the defined speed
	if velocity.length() > speed:
		velocity = velocity.normalized() * speed
