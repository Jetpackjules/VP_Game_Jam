extends TileMap

var tile_size = 64  # The size of your tiles
var map_size = 100  # The size of your map
var num_rooms = 10  # The number of rooms
var min_room_size = 5  # The minimum size of a room
var max_room_size = 15  # The maximum size of a room

class DungeonRoom:
	var x
	var y
	var width
	var height

	func _init(_x, _y, _width, _height):
		x = _x
		y = _y
		width = _width
		height = _height

	func intersects(other):
		return !(x + width <= other.x or other.x + other.width <= x or y + height <= other.y or other.y + other.height <= y)


func _ready():
	var rooms = []
	for i in range(num_rooms):
		var width = int(rand_range(min_room_size, max_room_size))
		var height = int(rand_range(min_room_size, max_room_size))
		var room_x = randi() % (map_size - width)
		var room_y = randi() % (map_size - height)
		var new_room = DungeonRoom.new(room_x, room_y, width, height)
		var overlap = false
		for room in rooms:
			if new_room.intersects(room):
				overlap = true
				break
		if not overlap:
			rooms.append(new_room)
			for x in range(new_room.x, new_room.x + new_room.width):
				for y in range(new_room.y, new_room.y + new_room.height):
					set_cell(x, y, 0)  # 0 is the index of the wall tile in your tileset
					
	for i in range(num_rooms - 1):
		var room1 = rooms[i]
		var room2 = rooms[i + 1]
		var point1 = Vector2(rand_range(room1.x, room1.x + room1.width), rand_range(room1.y, room1.y + room1.height))
		var point2 = Vector2(rand_range(room2.x, room2.x + room2.width), rand_range(room2.y, room2.y + room2.height))
		while point1 != point2:
			if point1.x < point2.x:
				point1.x += 1
			elif point1.x > point2.x:
				point1.x -= 1
			elif point1.y < point2.y:
				point1.y += 1
			elif point1.y > point2.y:
				point1.y -= 1
			set_cell(point1.x, point1.y, 0)  # 0 is the index of the wall tile in your tileset
