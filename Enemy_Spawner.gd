extends Node2D

var EnemyScene = preload("res://Enemies/Basher.tscn")  # Load the enemy scene (change path as needed)
var spawn_time_range = Vector2(1.0, 3.0)  # Minimum and maximum spawn times
onready var player = get_node("../Player")
var spawn_timer = Timer.new()  # Create the timer

func _ready():
	randomize()
	add_child(spawn_timer)  # Add the timer to the scene
	spawn_timer.connect("timeout", self, "spawn_enemy")  # Connect timer timeout signal to spawn_enemy function
	spawn_timer.start(rand_range(spawn_time_range.x, spawn_time_range.y))  # Start the timer with random timeout

func spawn_enemy():
	var enemy = EnemyScene.instance()  # Create an instance of the enemy
	enemy.global_position = get_random_spawn_position()  # Set its position off-screen
	add_child(enemy)  # Add it to the scene tree
	player.enemies.append(enemy)
	spawn_timer.start(rand_range(spawn_time_range.x, spawn_time_range.y))  # Restart the timer with new random timeout

func _process(delta):
	# pause or resume the spawn timer based on the game state
	if Global.game_paused and spawn_timer.is_stopped() == false:
		spawn_timer.stop()
	elif not Global.game_paused and spawn_timer.is_stopped() == true:
		spawn_timer.start(rand_range(spawn_time_range.x, spawn_time_range.y))  # Restart the timer with new random timeout



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
