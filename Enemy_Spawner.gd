extends Node2D

var EnemyScene = preload("res://Enemies/Basher.tscn")  # Load the enemy scene (change path as needed)
var spawn_time_range = Vector2(1.0, 3.0)  # Minimum and maximum spawn times
onready var player = get_node("../Player")

func _ready():
	randomize()
#this causes errors for some reason!
#	spawn_enemy()  # Spawn the first enemy immediately
	pass
	yield(get_tree().create_timer(1), "timeout")  # Wait for a random amount of time
	spawn_enemy() 
	
func spawn_enemy():
	
	var enemy = EnemyScene.instance()  # Create an instance of the enemy
	enemy.global_position = get_random_spawn_position()  # Set its position off-screen
	get_parent().add_child(enemy)  # Add it to the scene tree
	player.enemies.append(enemy)

	var spawn_time = rand_range(spawn_time_range.x, spawn_time_range.y)
	yield(get_tree().create_timer(spawn_time), "timeout")  # Wait for a random amount of time
	spawn_enemy()  # Then spawn another enemy

func get_random_spawn_position():
	var viewport_size = get_viewport_rect().size
	var spawn_margin = 100.0  # How far off-screen to spawn the enemies

	var spawn_position = Vector2(
		rand_range(-spawn_margin, viewport_size.x + spawn_margin),
		rand_range(-spawn_margin, viewport_size.y + spawn_margin)
	)

	# Adjust the position so it's off-screen on one axis
	if randf() < 0.5:
		spawn_position.x = -spawn_margin if randf() < 0.5 else viewport_size.x + spawn_margin
	else:
		spawn_position.y = -spawn_margin if randf() < 0.5 else viewport_size.y + spawn_margin

	return spawn_position
