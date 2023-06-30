extends Node2D

#const Player = preload("res://Player.tscn")
#const Exit = preload("res://ExitDoor.tscn")

var borders = Rect2(-18, -5, 38*4, 21*4)  # Multiply size by 4

onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19*4, 11*4), borders)  # Multiply position by 4
	var map = walker.walk(200, 1)  # Set complexity to 1
	
	# Set all cells in the tilemap to type 1 (wall)
	for x in range(int(borders.size.x)):
		for y in range(int(borders.size.y)):
			if not Vector2(x, y) in map:
				tileMap.set_cellv(Vector2(x, y), 1)
	
	# Set cells in the map to type 0 (floor)
	for location in map:
		tileMap.set_cellv(location, -1)
	
	# Post-processing to remove 1 by 1 spots
	for location in map:
		if location + Vector2(1, 1) in map and location + Vector2(-1, -1) in map and location + Vector2(-1, 1) in map and location + Vector2(1, -1) in map:
			continue
		tileMap.set_cellv(location, -1)
	
	walker.queue_free()
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	# Set player's position to a random location within the map
	var random_index = randi() % map.size()
	Global.player.position = map[random_index]*64  # Multiply position by 4
	
#	var player = Player.instance()
#	add_child(player)
	
#	var exit = Exit.instance()
#	add_child(exit)
#	exit.position = walker.get_end_room().position*32*4  # Multiply position by 4
#	exit.connect("leaving_level", self, "reload_level")

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
