extends Node2D

var EnemyScene = preload("res://Enemies/Hider.tscn")  # Load the enemy scene (change path as needed)
var spawn_time_range := Vector2(1.0, 3.0)  # Minimum and maximum spawn times
#onready var player = get_node("../Player")
var spawn_timer = Timer.new()  # Create the timer

var spawn_interval := 2.0  # Start with a 5-second interval
var spawn_interval_decrease := 0.1  # Decrease the interval by 0.1 each time an enemy spawns
var min_spawn_interval := 1.0  # Don't let the interval go below 1 second


var health_increase := 0.0  # Increase the health by 5 each time an enemy spawns
var speed_increase := 0.0

var spawned = false
func _ready():
	add_child(spawn_timer)  # Add the timer to the scene
	spawn_timer.connect("timeout", self, "spawn_enemy")  # Connect timer timeout signal to spawn_enemy function

#	randomize()

	spawn_timer.start(spawn_interval)  # Start the timer with initial spawn interval

func spawn_enemy():
	if !spawned:
		spawned = true
		var enemy = EnemyScene.instance()  # Create an instance of the enemy
		enemy.global_position = get_random_spawn_position()  # Set its position off-screen
	#	enemy.health += health_increase  # Set the enemy's health
	#	enemy.speed += speed_increase
		add_child(enemy)  # Add it to the scene tree
		Global.player.enemies.append(enemy)
		
		speed_increase += 0.3
		health_increase += 2.5
		
		# Decrease the spawn interval, but don't let it go below the minimum
		spawn_interval -= spawn_interval_decrease
		spawn_interval = max(min_spawn_interval, spawn_interval)
		
		# Start the timer with the new spawn interval
		spawn_timer.start(spawn_interval)

func _process(delta):
	# pause or resume the spawn timer based on the game state
	if Global.game_paused and spawn_timer.is_stopped() == false:
		spawn_timer.stop()
	elif not Global.game_paused and spawn_timer.is_stopped() == true:
		spawn_timer.start(spawn_interval)  # Restart the timer with new interval


func get_random_spawn_position():
	return(Global.player.global_position + Vector2(200, 0))
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
