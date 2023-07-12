extends Node2D

var enemy_folder_path = "res://Enemies"  # Path to the folder containing the enemy scenes
var enemy_scenes = []  # List of enemy scenes
export var total_enemies = 10  # Total number of enemies to spawn
var enemies_spawned = 0  # Number of enemies spawned so far

var spawn_time_range := Vector2(1.0, 3.0)  # Minimum and maximum spawn times
var spawn_timer = Timer.new()  # Create the timer

var spawn_interval := 2.0  # Start with a 5-second interval
var spawn_interval_decrease := 0.1  # Decrease the interval by 0.1 each time an enemy spawns
var min_spawn_interval := 1.0  # Don't let the interval go below 1 second

var health_increase := 0.0  # Increase the health by 5 each time an enemy spawns
var speed_increase := 0.0

export var enemy_type: PackedScene

func _ready():
#	print(enemy_type.get_type())
	add_child(spawn_timer)  # Add the timer to the scene
	spawn_timer.connect("timeout", self, "spawn_enemy")  # Connect timer timeout signal to spawn_enemy function

	spawn_timer.start(spawn_interval)  # Start the timer with initial spawn interval
	# Get a list of all the enemy scenes
	var dir = Directory.new()
	if dir.open(enemy_folder_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):  # Check if the file is a scene file
				var scene_path: String = enemy_folder_path + "/" + file_name
				var scene = load(scene_path)  # Preload the scene
				enemy_scenes.append(scene)  # Add it to the list
			file_name = dir.get_next()

func spawn_enemy():
	if enemies_spawned < total_enemies:  # Check if we've spawned all the enemies
		print("spawned!")
		var enemy
		if enemy_type:
			enemy = enemy_type.instance() 
		else:
			var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]  # Randomly select an enemy scene
			enemy = enemy_scene.instance()  # Create an instance of the enemy
		
		enemy.global_position = get_random_spawn_position()  # Set its position off-screen
		add_child(enemy)  # Add it to the scene tree

		speed_increase += 0.3
		health_increase += 2.5

		# Decrease the spawn interval, but don't let it go below the minimum
		spawn_interval -= spawn_interval_decrease
		spawn_interval = max(min_spawn_interval, spawn_interval)

		# Start the timer with the new spawn interval
		spawn_timer.start(spawn_interval)

		enemies_spawned += 1  # Increase the number of enemies spawned

func _process(delta):
	# pause or resume the spawn timer based on the game state
	if Global.game_paused and spawn_timer.is_stopped() == false:
		spawn_timer.stop()
	elif not Global.game_paused and spawn_timer.is_stopped() == true:
		spawn_timer.start(spawn_interval)  # Restart the timer with new interval

func get_random_spawn_position():
	var tilemap = Global.Tilemap_Floor
	var tilemap_scale = tilemap.scale.x  # Tilemap scale factor
	var tile_size = tilemap.cell_size * tilemap_scale
	var map_size = tilemap.get_used_rect().size

	var spawn_position = Vector2.ZERO
	var tile_type = -1

	var max_attempts = 1000
	var attempts = 0

	while tile_type != 0 and attempts < max_attempts:
		var tile_position = Vector2(
			int(rand_range(0, map_size.x)),
			int(rand_range(0, map_size.y))
		)
		tile_type = tilemap.get_cellv(tile_position)
		if tile_type == 0:
			spawn_position = tilemap.map_to_world(tile_position) * tilemap_scale + (tile_size/2)
#			print(spawn_position)
			return spawn_position
		attempts += 1

	print("FAILED TO SPAWN!")
	return spawn_position
