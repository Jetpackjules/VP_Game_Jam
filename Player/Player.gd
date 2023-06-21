extends KinematicBody2D

# Configurable variables
var acceleration: float = 200.0  # Increased
var max_speed: float = 300.0     # Increased
var deceleration: float = 100.0  # Increased
var rotation_speed: float = 3.0  # Increased

var water_shader = load("res://Water_Shader.tres")
# State variables
var velocity: Vector2 = Vector2()
var line : Line2D
var enemies : Array

func _ready():
	line = get_node("Line2D")
	enemies = get_tree().get_nodes_in_group("enemies")

func _process(delta):
	# Get input direction
	var direction: Vector2 = Vector2()

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	if direction.length() > 0:
		# Accelerate
		velocity += direction.normalized() * acceleration * delta
		velocity = velocity.clamped(max_speed)
	else:
		# Decelerate
		velocity = velocity.move_toward(Vector2(), deceleration * delta)

	# Handle rotation
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# Move the boat
	move_and_slide(velocity.rotated(rotation))

	var screen_size = get_viewport_rect().size
	var player_screen_pos = get_global_position() / screen_size
	water_shader.set_shader_param("player_pos", player_screen_pos)

	var closest_enemy = null
	var min_distance = INF

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	
	
	if closest_enemy != null:
		var direction_to_enemy = global_position.direction_to(closest_enemy.global_position).rotated(-rotation)
		line.points = [Vector2.ZERO, direction_to_enemy * min_distance]
		update()


func _draw():
#	print(line.points[1])

	if line.points.size() >= 2:
		draw_line(line.points[0], line.points[1], Color.green, 2.0)
