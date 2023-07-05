extends Node2D

onready var Tilemap_Wall = $Navigation2D/TileMap_Wall
onready var TileMap_Floor = $Navigation2D/TileMap_Floor

var rng = RandomNumberGenerator.new()
var grid = {}
var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 1
}

var furthest_tile = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("new_level"):
		new_level()

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
	for key in grid.keys():
		match grid[key]:
			Tiles.floor:
				TileMap_Floor.set_cellv(key, 0)
				sum += 1
			Tiles.wall:
				Tilemap_Wall.set_cellv(key, 1)  # Assuming 1 is the index of the wall tile
				sum += 1
	print(sum)

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
	Global.player.position = TileMap_Floor.map_to_world(furthest_tile)*1.5 + TileMap_Floor.cell_size / 2  # Teleport player to furthest tile

func _ready():
	Global.Nav = $Navigation2D
	Global.Tilemap_Wall = Tilemap_Wall
	Global.Tilemap_Floor = TileMap_Floor
	rng.randomize()
	new_level()
