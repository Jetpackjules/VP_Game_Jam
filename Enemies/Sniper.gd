extends KinematicBody2D

enum State {IDLE, AIMING, CHARGING, FIRING}

var state = State.IDLE
var charge_time = 0
var CHARGE_TIME = 1.5
var AIM_SPEED = 2.0
var CHARGE_SPEED = 1.0
var AIM_ANGLE = 30.0

onready var player_tracker = $Player_Tracker
onready var laser_sight = $Laser_Sight
onready var polygon2D = $Polygon2D  # Reference to the Polygon2D node
onready var laser_raycast = $Polygon2D/Laser_Raycast  # Reference to the Laser_Raycast node

var last_known_player_position = Vector2()

func _ready():
	laser_sight.points[1] = Vector2.ZERO  # Hide the laser sight

func _physics_process(delta):
	var player_direction = (player_tracker.player.global_position - global_position).normalized()
	var aim_direction = Vector2(cos(polygon2D.rotation), sin(polygon2D.rotation))
	var angle_to_player = acos(aim_direction.dot(player_direction)) * 180 / PI

	if player_tracker.player_visible:
		last_known_player_position = player_tracker.player.global_position

	match state:
		State.IDLE:
			if player_tracker.player_visible:
				state = State.AIMING
			else:
				rotate_polygon_towards_last_known_position(delta, AIM_SPEED)
		State.AIMING:
			if player_tracker.player_visible:
				rotate_polygon_towards_player(delta, AIM_SPEED)
				if angle_to_player < AIM_ANGLE:
					state = State.CHARGING
					charge_time = CHARGE_TIME
					update_laser_sight()  # Update the laser sight
			else:
				state = State.IDLE
		State.CHARGING:
			if player_tracker.player_visible and angle_to_player < AIM_ANGLE:
				rotate_polygon_towards_player(delta, CHARGE_SPEED)
				charge_time -= delta
				update_laser_sight()  # Update the laser sight
				if charge_time <= 0:
					state = State.FIRING
			else:
				state = State.IDLE
				laser_sight.points[1] = Vector2.ZERO  # Hide the laser sight
		State.FIRING:
			fire()
			state = State.IDLE
			laser_sight.points[1] = Vector2.ZERO  # Hide the laser sight

func rotate_polygon_towards_player(delta, speed):
	var player_direction = (player_tracker.player.global_position - global_position).normalized()
	var target_rotation = player_direction.angle()
	polygon2D.rotation = lerp_angle(polygon2D.rotation, target_rotation, speed * delta)

func rotate_polygon_towards_last_known_position(delta, speed):
	var direction = (last_known_player_position - global_position).normalized()
	var target_rotation = direction.angle()
	polygon2D.rotation = lerp_angle(polygon2D.rotation, target_rotation, speed * delta)

func update_laser_sight():
	laser_raycast.force_raycast_update()
	if laser_raycast.is_colliding():
		laser_sight.points[1] = laser_raycast.get_collision_point() - global_position
	else:
		laser_sight.points[1] = laser_raycast.cast_to

func fire():
	# Make the laser wide and bright red
	laser_sight.width = 10  # Adjust the width as needed
	laser_sight.default_color = Color(1, 0, 0, 1)  # Bright red color

	# Check if the raycast is colliding with the player
	laser_raycast.force_raycast_update()
	if laser_raycast.is_colliding():
		var collider = laser_raycast.get_collider()
		if collider == player_tracker.player:
			# Call the player's hit() function
			collider.hit()  # Make sure the player has a hit() function

	# Reset the laser sight after firing
	yield(get_tree().create_timer(0.5), "timeout")  # Wait for 0.5 seconds
	laser_sight.width = 5  # Reset the width
	laser_sight.default_color = Color(1, 0, 0, 0.5)  # Reset the color
