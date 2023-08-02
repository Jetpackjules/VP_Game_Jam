extends KinematicBody2D

enum State {IDLE, FIRING}

var state: int = State.IDLE
var last_known_player_position: Vector2 = Vector2()
var AIM_ANGLE: float = 45.0

export var damage := 1

onready var player_tracker: Node = $Player_Tracker
onready var laser_sight: Node = $Laser_Sight
onready var polygon2D: Node = $Polygon2D
onready var laser_raycast: Node = $Polygon2D/Laser_Raycast
onready var tween: Tween = $Tween
onready var charge_timer: Timer = $Charge_Timer
var shooting: bool = false

func _ready():
	laser_sight.points[1] = Vector2.ZERO
	

func _physics_process(delta):
	update_laser_sight()

	if player_tracker.player_visible:
		last_known_player_position = Global.player.global_position

	match state:
		State.IDLE:
#			polygon2D.modulate = Color.greenyellow
			if is_within_aim_angle() and player_tracker.player_visible:
				state = State.FIRING
				tween.interpolate_property(laser_sight, "width", laser_sight.width, 5, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
			else:
				shooting = false
				tween.interpolate_property(laser_sight, "width", laser_sight.width, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
			rotate_polygon_towards(last_known_player_position, delta)

		State.FIRING:
#			polygon2D.modulate = Color.red
			if player_tracker.player_visible and is_within_aim_angle():
				rotate_polygon_towards(Global.player.global_position, delta)
				if charge_timer.time_left == 0:
					charge_timer.start()
			else:
				state = State.IDLE

func rotate_polygon_towards(target_position, delta):
	if !shooting:
		var direction = (target_position - global_position).normalized()
		var target_rotation = direction.angle()
		polygon2D.rotation = lerp_angle(polygon2D.rotation, target_rotation, delta)

func update_laser_sight():
	laser_raycast.force_raycast_update()
	if laser_raycast.is_colliding():
		laser_sight.points[1] = laser_raycast.get_collision_point() - global_position
	else:
		laser_sight.points[1] = laser_raycast.cast_to

func fire():
	shooting = true
	tween.interpolate_property(laser_sight, "width", laser_sight.width, 11, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(0.15), "timeout")

	laser_raycast.set_collision_mask_bit(2, true)
	laser_raycast.force_raycast_update()
	if laser_raycast.is_colliding():
		var collider = laser_raycast.get_collider()
		if collider == Global.player:
			collider.hit(damage, collider.global_position-global_position)
	laser_raycast.set_collision_mask_bit(2, false)
	
	tween.interpolate_property(laser_sight, "width", laser_sight.width, 5, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	shooting = false
	charge_timer.start()

func _on_Charge_Timer_timeout():
	if state == State.FIRING:
		fire()

func is_within_aim_angle():
	var player_direction = (Global.player.global_position - global_position).normalized()
	var aim_direction = Vector2(cos(polygon2D.rotation), sin(polygon2D.rotation))
	var angle_to_player = acos(aim_direction.dot(player_direction)) * 180 / PI
	return angle_to_player < AIM_ANGLE
