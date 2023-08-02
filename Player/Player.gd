extends KinematicBody2D
#SUIZE IS 2.3 for camera
# Configurable variables
var speed: float= 300.0     # Constant speed
var fire_speed: float = 1.0  # Fires every second
var fire_amount: int = 1     # Fires 1 projectile at a time
export var health: int = 3    # Player's health
var heal_percent: float = 0.0    # Player's health

onready var sprite = $Polygon2D
onready var health_counter = get_node("HealthBar")

var velocity: Vector2 = Vector2()
var fire_timer : Timer

var facing_rotation := 0.0

var invincible: bool = false
export var invincibility_duration: float = 1.0  # 2 seconds of invincibility
onready var invincibility_timer = get_node("invincibility_timer")

var dead := false

func _ready():
	Global.player = self
	$HealthBar.max_health = health


#func _input(event):
#	if event.is_action_pressed("ui_fire") and !Global.game_paused:
#		weapon.fire()

func _process(delta):
#	enemy_hider.rotation = -rotation
#	env_light.rotation = -rotation
	
	if Global.game_paused:
		return

	# Player always faces the mouse
	facing_rotation = get_global_mouse_position().angle_to_point(global_position)
	sprite.rotation = facing_rotation

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


func hit(damage: float, knockback_location: Vector2):
	if invincible or dead:
		return
	
	Global.shake(.3)
	health_counter.take_damage(damage)
	health -= damage
	print(health)
	if health <= 0:
		die()
	else:
		var knockback = (global_position - knockback_location).normalized() * 200  # Modify 200 to adjust knockback strength
		velocity += knockback
#		get_node("Proximity_Death").monitoring = false
		invincible = true
		invincibility_timer.start(invincibility_duration)  # Start the invincibility timer
		sprite.modulate = Color.red

	
func die():
	dead = true
#	invincibility_timer.stop()
#	Global.pause()
	print("Player died!")  # Replace with actual death logic


#	# Make the Polygon2D flash red
#	tween.interpolate_property(polygon2D, "modulate", polygon2D.modulate, Color.red, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#	yield(tween, "tween_all_completed")
#
#	# Return the Polygon2D to its original color
#	tween.interpolate_property(polygon2D, "modulate", polygon2D.modulate, Color.white, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
#	yield(tween, "tween_all_completed")
	Global.return_to_menu()

func _on_invincibility_timer_timeout():
	if !dead:
		invincible = false
#		get_node("Proximity_Death").monitoring = true
		sprite.modulate = Color.white  # Return the sprite to its normal color

