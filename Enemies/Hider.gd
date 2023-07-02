extends KinematicBody2D

var speed = 200
var player_detected = false
var hiding_spot = Vector2.ZERO
var is_moving_to_hiding_spot = false
var is_finding_hiding_spot = false

onready var raycast = $RayCast2D  # Add a RayCast2D node as a child of the enemy
onready var player = Global.player
onready var tilemap = Global.Tilemap_Wall

func _physics_process(delta):
	raycast.cast_to = player.position - position  # Set the raycast to point towards the player
	raycast.force_raycast_update()  # Update the raycast

	if raycast.is_colliding() and raycast.get_collider() == player:
		player_detected = true
		if not is_moving_to_hiding_spot and not is_finding_hiding_spot:
			is_finding_hiding_spot = true
			find_hiding_spot()
	else:
		player_detected = false
		is_moving_to_hiding_spot = false

	if player_detected:
		var direction_to_player = (player.position - position).normalized()
		move_and_slide(direction_to_player * speed)
	else:
		var direction_to_hiding_spot = (hiding_spot - position).normalized()
		move_and_slide(direction_to_hiding_spot * speed)
		if position.distance_to(hiding_spot) < 1:
			is_moving_to_hiding_spot = false

func find_hiding_spot():
	var start_pos = tilemap.world_to_map(position)
	var queue = [start_pos]
	var visited = {start_pos: true}
	var directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	var timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "_on_timer_timeout", [queue, visited, directions])
	add_child(timer)
	timer.start()

func _on_timer_timeout(queue, visited, directions):
	if queue.size() == 0:
#		get_node("Timer").queue_free()
		is_finding_hiding_spot = false
		return

	var current_pos = queue.pop_front()
	for direction in directions:
		var next_pos = current_pos + direction
		if next_pos in visited:
			continue

		visited[next_pos] = true
		if tilemap.get_cellv(next_pos) != -1:
			var raycast_to_player = RayCast2D.new()
			raycast_to_player.set_cast_to(player.position - tilemap.map_to_world(next_pos))
			raycast_to_player.set_cast_to(tilemap.map_to_world(next_pos))
			raycast_to_player.force_raycast_update()
			if not raycast_to_player.is_colliding() or raycast_to_player.get_collider() != player:
				hiding_spot = tilemap.map_to_world(next_pos)
				is_moving_to_hiding_spot = true
#				get_node("Timer").queue_free()
				is_finding_hiding_spot = false
				return

		queue.push_back(next_pos)
	tilemap.set_cellv(current_pos, 2)
	yield(get_tree().create_timer(0.5), "timeout")
	tilemap.set_cellv(current_pos, -1)
