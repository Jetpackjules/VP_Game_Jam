extends Node
class_name Walker

var position = Vector2.ZERO
var size = Vector2.ZERO
var borders = Rect2()
var step_history = []

func _init(starting_position, room_size, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	size = room_size
	borders = new_borders

# In the Walker class
func walk():
	for x in range(int(size.x)):
		for y in range(int(size.y)):
			var cell_position = position + Vector2(x, y)
			if borders.has_point(cell_position) and not step_history.has(cell_position):
				step_history.append(cell_position)
	return step_history
