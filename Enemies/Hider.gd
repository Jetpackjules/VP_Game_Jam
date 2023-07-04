extends KinematicBody2D

enum State {IDLE, FINDING_HIDING_SPOT, MOVING_TO_HIDING_SPOT, ATTACKING_PLAYER}

var speed = 500
var state = State.IDLE
var hiding_spot = Vector2.ZERO
var attack_distance = 400  # The distance at which the enemy will start attacking the player

onready var raycast = $RayCast2D
onready var player = Global.player
onready var tile_map = Global.Tilemap_Wall
onready var tile_map_floor = Global.Tilemap_Floor

onready var navigation = Global.Nav
onready var agent = $NavigationAgent2D



var line: Line2D

var move_velocity

var velocity = Vector2.ZERO
var damping = 0.48  # Adjust this value to change the damping effect


func _ready():
	agent.set_navigation(navigation)
	state = State.FINDING_HIDING_SPOT


func _physics_process(delta):
	raycast.cast_to = Global.player.global_position - global_position
	raycast.force_raycast_update()
	
	match state:
		State.IDLE:
			if raycast.is_colliding() and raycast.get_collider() == player:
				if position.distance_to(player.position) < attack_distance:
					state = State.ATTACKING_PLAYER
				else:
					state = State.FINDING_HIDING_SPOT
		State.FINDING_HIDING_SPOT:
			hiding_spot = find_nearest_available_tile()
			if hiding_spot != null:
				agent.set_target_location(hiding_spot)
				state = State.MOVING_TO_HIDING_SPOT
			else:
				state = State.ATTACKING_PLAYER
		State.MOVING_TO_HIDING_SPOT:
			if agent.is_navigation_finished():
				state = State.IDLE
			else:
				var next_location = agent.get_next_location()
				var target_direction = (next_location - global_position).normalized()
				var target_velocity = target_direction * speed
				velocity += (target_velocity - velocity) * damping
				agent.set_velocity(velocity)
		State.ATTACKING_PLAYER:
			var direction_to_player = (player.position - position).normalized()
			move_and_slide(direction_to_player * speed)
			hiding_spot = find_nearest_available_tile()
			if position.distance_to(player.position) > attack_distance and hiding_spot != null:
				state = State.IDLE




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
			
			pred_cast.position = direction * distance
			pred_cast.cast_to = Global.player.global_position - pred_cast.global_position
			pred_cast.force_raycast_update()
			if pred_cast.get_collider() != player:
				var new_pos = pred_cast.global_position
				var tile_position = tile_map_floor.world_to_map(new_pos / tile_map_floor.scale)  # Adjust for scale
				
				if tile_map_floor.get_cellv(tile_position) == 0:
					pred_cast.queue_free()
					return new_pos
	pred_cast.queue_free()
	return null

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	velocity = move_and_slide(safe_velocity) 
