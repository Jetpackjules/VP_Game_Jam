extends KinematicBody2D

# Configurable variables
var speed: float = 500.0     # Constant speed
var fire_speed: float = 1.0  # Fires every second
var fire_amount: int = 1     # Fires 1 projectile at a time
var health: float = 100.0    # Player's health
var heal_percent: float = 0.0    # Player's health

onready var thruster_particles = get_node("Trail")
onready var healthbar = get_node("../Player_HealthBar")
onready var menu = get_node("../Menu")
onready var emitters = get_node("Emitters")
onready var camera = get_node("../Camera2D")

# State variables
var velocity: Vector2 = Vector2()
onready var line = get_node("Line2D")
var enemies : Array = []
var closest_enemy = null
var fire_timer : Timer

func _ready():
	emitters.add_child(load("res://Projectiles/Basic/Emitter.tscn").instance())

func _input(event):
	if event.is_action_pressed("ui_fire") and !Global.game_paused:
		for emitter in emitters.get_children():
			emitter.emit_projectiles()
	
func _process(delta):
	if Global.game_paused:
		return

	# Player always faces the mouse
	rotation = get_global_mouse_position().angle_to_point(global_position)

	# Get input for movement
	var move_dir: Vector2 = Vector2()

	if Input.is_action_pressed("ui_up"):
		move_dir.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		move_dir.y += 1.0
	if Input.is_action_pressed("ui_left"):
		move_dir.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		move_dir.x += 1.0

	# Smoothly transition velocity towards desired direction
	var target_velocity = move_dir.normalized() * speed
	velocity = velocity.linear_interpolate(target_velocity, 0.1)

	# Move the player
	move_and_slide(velocity)
	for emitter in emitters.get_children(): # Set the origin_angle of all emitters
		emitter.origin_angle = rotation_degrees

	# Heal
	health += (heal_percent/100) * health * delta
	healthbar.value = health


# Function to apply damage and knockback
func hit(damage: float, knockback_location: Vector2):
	health = clamp(health, healthbar.min_value, healthbar.max_value)
	health -= damage
	if health <= 0:
		die()
	else:
		var knockback = (global_position - knockback_location).normalized() * 200 
		velocity += knockback
	
	healthbar.set_health(health)
	
func die():
	print("Player died!")  
	menu.reset()
