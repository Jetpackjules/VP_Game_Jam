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

func _ready():
	laser_sight.points[1] = Vector2.ZERO  # Hide the laser sight

func _physics_process(delta):
	var player_direction = (player_tracker.player.global_position - global_position).normalized()
	var aim_direction = Vector2(cos(polygon2D.rotation), sin(polygon2D.rotation))
	var angle_to_player = acos(aim_direction.dot(player_direction)) * 180 / PI

	match state:
		State.IDLE:
			if player_tracker.player_visible:
				state = State.AIMING
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

func update_laser_sight():
	laser_raycast.force_raycast_update()
	if laser_raycast.is_colliding():
		laser_sight.points[1] = laser_raycast.get_collision_point() - global_position
	else:
		laser_sight.points[1] = laser_raycast.cast_to

func fire():
	# Implement your firing logic here
	pass
