extends Node2D

onready var Tilemap_Wall = $TileMap_Wall
onready var TileMap_Floor = $TileMap_Floor
onready var TileMap_Border = $Navigation2D/TileMap_Border
var rng = RandomNumberGenerator.new()
var grid = {}
var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 1,
	"border": 10,
	"no_border": 11
}

var furthest_tile = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("new_level"):
		new_level()
		Global.player.health_counter.set_max_health(Global.player.health_counter.max_health+1)

func GetRandomDirection():
	var directions = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1), Vector2(0, -1)]
	return directions[rng.randi()%4]

func _create_random_path():
	var max_iterations = 300  # Limit the total amount of floor tiles
	var itr = 0
	
	var walker = Vector2.ZERO
	
	while itr < max_iterations:
		# Perform random walk
		var random_direction = GetRandomDirection()
		walker += random_direction
		grid[walker] = Tiles.floor
		itr += 1

var sum = 0

func _spawn_tiles():
	sum = 0
	for key in grid.keys():
		match grid[key]:
			Tiles.floor:
				TileMap_Floor.set_cellv(key, 0)
				sum += 1
				# Spawn border tiles
				for dx in range(3):
					for dy in range(3):
						var border_key = key * 3 + Vector2(dx, dy)
						TileMap_Border.set_cellv(border_key, 0)
			Tiles.wall:
				Tilemap_Wall.set_cellv(key, 1)  # Assuming 1 is the index of the wall tile
				sum += 1
			_:
				print("ERROR TILE!")
	remove_border_tiles()
	print("SUM: ", sum)

func remove_border_tiles():
	# Spawn border tiles
	for key in grid.keys():
		if grid[key] == Tiles.floor:
			var directions = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
			for direction in directions:
				var neighbor = key + direction
				if grid.has(neighbor) and grid[neighbor] == Tiles.wall:
					for dx in range(3):
						for dy in range(3):
							var border_key = key * 3 + Vector2(dx, dy)
							if direction == Vector2(-1, 0) and dx == 0:  # Left
								TileMap_Border.set_cellv(border_key, -1)
							elif direction == Vector2(1, 0) and dx == 2:  # Right
								TileMap_Border.set_cellv(border_key, -1)
							elif direction == Vector2(0, -1) and dy == 0:  # Up
								TileMap_Border.set_cellv(border_key, -1)
							elif direction == Vector2(0, 1) and dy == 2:  # Down
								TileMap_Border.set_cellv(border_key, -1)




func _add_walls():
	for key in grid.keys():
		if grid[key] == Tiles.floor:
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					var neighbor = key + Vector2(dx, dy)
					if not grid.has(neighbor):
						grid[neighbor] = Tiles.wall

func _clear_tilemaps():
	Tilemap_Wall.clear()
	TileMap_Floor.clear()
	TileMap_Border.clear()
	grid.clear()

func new_level():
	_clear_tilemaps()
	_create_random_path()
	_add_walls()
	_spawn_tiles()
	find_furthest_tile()

func find_furthest_tile():
	var visited = {}
	var queue = []
	var center = Vector2.ZERO
	queue.append(center)
	visited[center] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		for dx in range(-1, 2):
			for dy in range(-1, 2):
				var neighbor = current + Vector2(dx, dy)
				if grid.has(neighbor) and grid[neighbor] == Tiles.floor and not visited.has(neighbor):
					queue.append(neighbor)
					visited[neighbor] = true
		furthest_tile = current

	while Global.player == null:
		yield(get_tree().create_timer(0.0000001), "timeout")  # Wait until Global.player is not null
	Global.player.position = TileMap_Floor.map_to_world(furthest_tile) + TileMap_Floor.cell_size / 2  # Teleport player to furthest tile

func _ready():
	Global.Nav = $Navigation2D
	Global.Tilemap_Wall = Tilemap_Wall
	Global.Tilemap_Floor = TileMap_Floor
	rng.randomize()
	new_level()
