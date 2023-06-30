extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var last_direction = Vector2.ZERO
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps, complexity):
	for step in range(steps * complexity):  # Multiply steps by complexity
		if steps_since_turn >= rand_range(2, 6):  # Add randomness to direction changes
			change_direction()
			if last_direction != direction:  # If the walker changed direction, place a room at the end of the hallway
				place_room(position - last_direction)
			if randf() < 0.1:  # 10% chance to place a room
				place_room(position)
			else:
				place_hallway(position)
		
		if not step():  # If the next step is not valid, place a room at the current position
			place_room(position)
		else:
			step_history.append(position)
		
		if randf() < 0.05:  # 5% chance to skip a step
			position += direction
		last_direction = direction
	return step_history


func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2((randi() % 4 + 2) * 4, (randi() % 4 + 2)/2)  # Multiply size by 4
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in range(int(size.y)):
		for x in range(int(size.x)):
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func place_hallway(position):
	var size = Vector2(4, 4)  # Set hallway size to 4x4
	var top_left_corner = (position - size/2).ceil()
	for y in range(int(size.y)):
		for x in range(int(size.x)):
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
