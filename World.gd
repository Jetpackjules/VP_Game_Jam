extends Node2D

onready var Tilemap_Wall = $TileMap_Wall
onready var TileMap_Floor = $TileMap_Floor

var rng = RandomNumberGenerator.new()

var grid = {}

var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 1
}

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

#func _clear_tilemaps():
#	tilemap.clear()
#	tilemap.update_bitmask_region()

func _ready():
	Global.Tilemap_Wall = Tilemap_Wall
	rng.randomize()
#	_clear_tilemaps()
	_create_random_path()
	_add_walls()
	_spawn_tiles()
