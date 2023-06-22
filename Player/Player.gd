extends KinematicBody2D

# Configurable variables
var acceleration: float = 400.0  # Increased
var max_speed: float = 500.0     # Increased
var deceleration: float = 100.0  # Increased
var rotation_speed: float = 3.0  # Increased
var fire_speed: float = 1.0      # Fires every second
var fire_amount: int = 1         # Fires 1 projectile at a time

var water_shader = load("res://Water_Shader.tres")
onready var emitters = get_node("Emitters")
onready var camera = get_node("../Camera2D")
# State variables
var velocity: Vector2 = Vector2()
var line : Line2D
var enemies : Array = []
var closest_enemy = null
var fire_timer : Timer

onready var clone_holder = get_node("Clone_Holder")
func _ready():
	emitters.add_child(load("res://Projectiles/Basic/Emitter.tscn").instance())
	# cloning sprite:
#	var screen_size = get_viewport_rect().size*camera.zoom.x
#	var screen_size = Vector2(500, 500)
#	# Create 4 clones of the player sprite
#	for i in range(4):
#		var clone = duplicate()
#		clone.position += Vector2(screen_size.x if i % 2 == 0 else 0, screen_size.y if i < 2 else 0)
#		clone_holder.add_child(clone)

	line = get_node("Line2D")
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_speed
	fire_timer.one_shot = false
	fire_timer.connect("timeout", self, "_on_fire_timer_timeout")
	add_child(fire_timer)
	fire_timer.start()


#	enemies = get_tree().get_nodes_in_group("enemies")

func _input(event):
	if Input.is_action_just_pressed("ui_select"):
		if closest_enemy != null:
			enemies.erase(closest_enemy)
			closest_enemy.queue_free()  # Remove the enemy from the scene
			closest_enemy = null
	elif Input.is_action_just_pressed("increase_bullets"):
		for emitter in emitters.get_children():
			emitter.amount_emitted += 1



func _process(delta):
	for emitter in emitters.get_children():
		emitter.rotation = rotation
	# Get input for thrust
	var thrust: float = 0.0

	if Input.is_action_pressed("ui_up"):
		thrust = 1.0

	if thrust > 0:
		# Accelerate
		var accel_direction = Vector2(0, -1).rotated(rotation)
		velocity += accel_direction * acceleration * delta
		velocity = velocity.clamped(max_speed)
	else:
		# We don't have deceleration in Asteroids, but if you'd like it:
		velocity = velocity.move_toward(Vector2(), deceleration * delta)

	# Handle rotation
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# Move the boat
	move_and_slide(velocity)

	# Screen wrapping logic
	var screen_size = get_viewport_rect().size*camera.zoom.x
	if position.x < -screen_size.x/2:
		position.x = screen_size.x/2
	elif position.x > screen_size.x/2:
		position.x = -screen_size.x/2
	if position.y < -screen_size.y/2:
		position.y = screen_size.y/2
	elif position.y > screen_size.y/2:
		position.y = -screen_size.y/2
	
	
	var player_screen_pos = get_global_position() / screen_size
	water_shader.set_shader_param("player_pos", player_screen_pos)

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
