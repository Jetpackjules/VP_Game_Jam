extends Control

func _on_Button_pressed():
	Global.game_paused = false
	visible = false
	pass # Replace with function body.

func reset():
	Global.game_paused = true
	visible = true


	score.increase_score(-score.score)
	score.card_checkpoint = 0
	player_health.set_health(100)

	# Assuming the script is attached to a Node named 'MyNode'
#	var PlayerScene = preload("res://Player/Player.tscn") # Load the scene or node
#
#	# To reset the node:
#	var parentNode = player.get_parent() # Get the parent of the current node
##	var myNodePos = player.get_position() # Store the old position if needed
#	player.queue_free() # Free the current node
#
#	# Create a new instance of the node and add it to the scene tree
#	var player_new = PlayerScene.instance()
#	parentNode.add_child(player_new)
#	newMyNode.set_position(myNodePos) # Set the position to the old position

	enemy_spawner.speed_increase = 0
	enemy_spawner.health_increase = 0
	enemy_spawner.spawn_interval = 5.0


onready var enemy_spawner = get_node("../Enemy_Spawner")
onready var score = get_node("../Score")
onready var player_health = get_node("../Player_HealthBar")
onready var player = get_node("../Player")

