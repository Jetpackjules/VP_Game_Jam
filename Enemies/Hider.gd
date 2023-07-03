extends KinematicBody2D


onready var raycast = $RayCast2D
onready var player = Global.player
onready var tile_map = Global.Tilemap_Wall
onready var tile_map_floor = Global.Tilemap_Floor
onready var polygon2D = $Polygon2D
onready var navigation = Global.Nav
onready var agent = $NavigationAgent2D

var speed = 100
var state = 0

var tile_position = null

# Define colors for different states
var colors = [Color.red, Color.green, Color.blue]

var circle_radius = 10.0
var circle_color = Color.red
var line_color = Color.blue

var positions = []


func _draw():
	if positions.size() >= 1:
		for i in range(positions.size() - 1):
			# Draw line between consecutive positions
			draw_line(positions[i], positions[i + 1], line_color)
			
			# Draw circle at each position
			draw_circle(positions[i], circle_radius, circle_color)
		
		# Draw circle at the last position
		draw_circle(positions[positions.size() - 1], circle_radius, circle_color)



func _ready():
	agent.set_navigation(navigation)

func _physics_process(delta):
	raycast.cast_to = Global.player.global_position - global_position
	# Change color depending on state
	modulate = colors[state]
	
	
	print(agent.is_navigation_finished())
	positions = agent.get_nav_path()
	
	update()
	if agent.distance_to_target() > 1:
		var next_location = agent.get_next_location()
		var direction = (next_location - global_position).normalized()
		var velocity = direction * speed
		agent.set_velocity(velocity)
		move_and_slide(velocity)  # Assuming you have a speed variable

	# Use raycast to find nearest available tile with no sightline to the player
	if tile_position == null:
		tile_position = find_nearest_available_tile()
		if tile_position != null:
			tile_map.set_cellv(tile_position, 2)
			agent.set_target_location(tile_map.map_to_world(tile_position))

func find_nearest_available_tile():
	var pred_cast = RayCast2D.new()
	add_child(pred_cast)
	pred_cast.enabled = true
	
	for distance in range(0, 1000, 32):  # Check every 32 pixels
		for angle in range(0, 360, 10):  # Check every 10 degrees
			var direction = Vector2(cos(angle), sin(angle))
			pred_cast.position = direction * distance
			pred_cast.cast_to = Global.player.global_position - pred_cast.global_position
			pred_cast.force_raycast_update()
			if pred_cast.get_collider() != player:
				var new_pos = pred_cast.global_position
				var tile_position = tile_map_floor.world_to_map(new_pos)
				
				if tile_map_floor.get_cellv(tile_position) == 0:
					pred_cast.queue_free()
					return tile_position
	pred_cast.queue_free()
	return null
