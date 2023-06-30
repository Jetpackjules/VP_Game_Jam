extends KinematicBody2D

# Configurable variables
var speed: float = 500.0     # Constant speed
var fire_speed: float = 1.0  # Fires every second
var fire_amount: int = 1     # Fires 1 projectile at a time
var health: float = 100.0    # Player's health
var heal_percent: float = 0.0    # Player's health

# State variables
var velocity: Vector2 = Vector2()
var enemies : Array = []
var closest_enemy = null
var fire_timer : Timer

# Weapon
onready var weapon = get_node("Weapon")


func _ready():
	Global.player = self


func _input(event):
	if event.is_action_pressed("ui_fire") and !Global.game_paused:
		weapon.fire()

func _process(delta):
	if Global.game_paused:
		return

	# Player always faces the mouse
	rotation = get_global_mouse_position().angle_to_point(global_position)
	weapon.rotation = rotation  # Make the weapon face the same direction as the player

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
	move_and_slide(velocity)

	# Heal
	health += (heal_percent/100) * health * delta

# Function to apply damage and knockback
func hit(damage: float, knockback_location: Vector2):
	health -= damage
	if health <= 0:
		die()
	else:
		var knockback = (global_position - knockback_location).normalized() * 200  # Modify 200 to adjust knockback strength
		velocity += knockback
	
func die():
	print("Player died!")  # Replace with actual death logic
