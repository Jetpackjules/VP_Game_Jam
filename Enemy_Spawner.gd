extends Node2D

var enemy_folder_path = "res://Enemies"  # Path to the folder containing the enemy scenes
var enemy_scenes = []  # List of enemy scenes
export var total_enemies = 10  # Total number of enemies to spawn
var enemies_spawned = 0  # Number of enemies spawned so far

var speed_increase := 0.0
var health_increase := 0.0

export var enemy_type: PackedScene

func _ready():
	Global.connect("new_level", self, "reset_enemies")
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


func spawn_enemies():
	for i in range(total_enemies):  # Spawn all enemies at once
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

	enemies_spawned = total_enemies  # Set the number of enemies spawned to total_enemies


#func _process(delta):
#	# pause or resume the spawn timer based on the game state
#	if Global.game_paused and spawn_timer.is_stopped() == false:
#		spawn_timer.stop()
#	elif not Global.game_paused and spawn_timer.is_stopped() == true:
#		spawn_timer.start(spawn_interval)  # Restart the timer with new interval

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
			int(rand_range(-map_size.x, map_size.x)),
			int(rand_range(-map_size.y, map_size.y))
		)
		tile_type = tilemap.get_cellv(tile_position)
		if tile_type == 0:
			spawn_position = tilemap.map_to_world(tile_position) * tilemap_scale + (tile_size/2)
#			print(spawn_position)
			return spawn_position
		attempts += 1

	print("FAILED TO SPAWN!")
	return spawn_position

func clear_enemies():
	for child in get_children():
		child.queue_free()  # Remove the child

func reset_enemies():
	clear_enemies()
	spawn_enemies()

