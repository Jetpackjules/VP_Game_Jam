extends Control

func _on_Button_pressed():
	Global.game_paused = false
	visible = false
	pass # Replace with function body.

func reset():
	Global.game_paused = true
	visible = true
	for enemy in player.enemies:
		enemy.queue_free()
	player.enemies.clear()
	score.increase_score(-score.score)
	score.card_checkpoint = 0
	player_health.set_health(100)

	enemy_spawner.speed_increase = 0
	enemy_spawner.health_increase = 0
	enemy_spawner.spawn_interval = 5.0



onready var enemy_spawner = get_node("../Enemy_Spawner")
onready var score = get_node("../Score")
onready var player_health = get_node("../Player_HealthBar")
onready var player = get_node("../Player")

