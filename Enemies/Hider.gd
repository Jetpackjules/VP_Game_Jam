extends KinematicBody2D

enum State {IDLE, FINDING_HIDING_SPOT, MOVING_TO_HIDING_SPOT, ATTACKING_PLAYER, KNOCKBACK}

var speed = 300
var state = State.IDLE
var hiding_spot = Vector2.ZERO
var attack_distance = 400  # The distance at which the enemy will start attacking the player
var knockback_timer = 0  # Timer to reduce knockback effect

onready var raycast = $Player_Tracker
onready var player = Global.player
onready var tile_map = Global.Tilemap_Wall
onready var tile_map_floor = Global.Tilemap_Floor
onready var navigation = Global.Nav
onready var movement_module = $Navigation


onready var polygon1 = $Polygon2D2/Polygon2D
onready var polygon2 = $Polygon2D2

var time_since_last_sight = 0.0

var velocity = Vector2.ZERO
var damping = 0.68  # Adjust this value to change the damping effect

func _ready():
#	agent.set_navigation(navigation)
	state = State.FINDING_HIDING_SPOT

func _physics_process(delta):
	# update rotation of polygons
	var rotation_speed = speed * delta
	polygon1.rotation += rotation_speed
#	polygon2.rotation -= rotation_speed
	
	if Global.game_paused:
		return

	

	match state:
		State.IDLE:
			if raycast.player_visible:
				if position.distance_to(player.position) < attack_distance:
					state = State.ATTACKING_PLAYER
				else:
					state = State.FINDING_HIDING_SPOT
		State.FINDING_HIDING_SPOT:
			hiding_spot = find_nearest_available_tile()
			if hiding_spot != null:
				state = State.MOVING_TO_HIDING_SPOT
			else:
				state = State.ATTACKING_PLAYER
		State.MOVING_TO_HIDING_SPOT:
			movement_module.set_target_location(hiding_spot)
#			if !movement_module.is_target_reachable():
#				print("UNREACHABLE")
#				breakpoint # THIS SHOULD NEVER HAPPEN!
			speed = 500
			if movement_module.is_navigation_finished():
				state = State.IDLE
			else:
				var next_location = movement_module.get_next_location()
				var target_direction = (next_location - global_position).normalized()
				var target_velocity = target_direction * speed
				velocity += (target_velocity - velocity) * damping
				movement_module.set_velocity(velocity)

		State.ATTACKING_PLAYER:
			speed = 300
			var direction_to_player = (player.position - position).normalized()
			
#			movement_module.set_target_location(player.global_position)
#			var next_location = movement_module.get_next_location()
#			var target_direction = (next_location - global_position).normalized()
#			var target_velocity = target_direction * speed
#			movement_module.set_velocity(direction_to_player * speed)

			movement_module.move_to_target(player.position)
			
			if !raycast.player_visible:
				time_since_last_sight += delta
			else:
				time_since_last_sight = 0.0
				
			hiding_spot = find_nearest_available_tile()
			if position.distance_to(player.position) > attack_distance or time_since_last_sight > 1.5:
				if hiding_spot != null:
					state = State.MOVING_TO_HIDING_SPOT
#			elif time_since_last_sight > 1.5 and hiding_spot != null:
#				state = State.MOVING_TO_HIDING_SPOT
			
		State.KNOCKBACK:
			pass






func find_nearest_available_tile():
	var pred_cast = RayCast2D.new()
	add_child(pred_cast)
	pred_cast.enabled = true
	
	var player_direction = (player.global_position - global_position).normalized()
	
	for distance in range(200, 1000, 32):  # Check every 32 pixels
		for angle in range(0, 360, 10):  # Check every 10 degrees
			var direction = Vector2(cos(angle), sin(angle))
			
			# Skip directions that are towards the player
			if direction.dot(player_direction) > 0:
				continue
			
			var test_point = to_global(direction * distance)
			var tile_position = tile_map_floor.world_to_map(test_point / tile_map_floor.scale)
			
			if tile_map_floor.get_cellv(tile_position) == 0:
				
				
				var closest_point = navigation.get_closest_point(test_point)

				pred_cast.global_position = closest_point
				pred_cast.cast_to = Global.player.global_position - closest_point
				pred_cast.force_raycast_update()
				if pred_cast.get_collider() != player:
#					var new_pos = pred_cast.global_position
#					var tile_position = tile_map_floor.world_to_map(new_pos / tile_map_floor.scale)  # Adjust for scale
#
#					if tile_map_floor.get_cellv(tile_position) == 0:
					pred_cast.queue_free()
					return closest_point
	pred_cast.queue_free()
	return null

#func _on_NavigationAgent2D_velocity_computed(safe_velocity):
#	velocity = move_and_slide(safe_velocity) 

