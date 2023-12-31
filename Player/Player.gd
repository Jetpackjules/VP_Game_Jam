extends KinematicBody2D
#SUIZE IS 2.3 for camera
# Configurable variables
var speed: float= 300.0     # Constant speed


var heal_percent: float = 0.0    # Player's health

onready var sprite = $Polygon2D
onready var light_blocker = $light_blocker
onready var health_counter = get_node("Health_Counter")
onready var weapon = get_node("Weapon")

var velocity: Vector2 = Vector2()
var fire_timer : Timer

var facing_rotation := 0.0

var invincible: bool = false
export var invincibility_duration: float = 1.0  # 2 seconds of invincibility
onready var invincibility_timer = get_node("invincibility_timer")

var modifiers: Dictionary = {"run_away": false}
var run_away_time := 3.0

var dead := false

func _ready():
	Global.player = self



func _process(delta):
#	enemy_hider.rotation = -rotation
#	env_light.rotation = -rotation
	
	if Global.game_paused:
		return

	# Player always faces the mouse
	facing_rotation = get_global_mouse_position().angle_to_point(global_position)
	sprite.rotation = facing_rotation
	light_blocker.rotation = facing_rotation + light_blocker.increment/2 # + 0.785398 # 45 degrees in radians

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
	
	if (modifiers["run_away"]):
		speed_boost(run_away_time)


	Global.shake(.3)
	health_counter.take_damage(damage)

	if health_counter.current_health <= 0:
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


func speed_boost(time: float):
	var test = get_node("Speed Boost")
	var test2 = get_node("Speed Boost").time_left
	if get_node("Speed Boost").time_left <= 0:
		speed *= 1.4
	get_node("Speed Boost").start(time)

func _on_Speed_Boost_timeout():
	speed /= 1.4

