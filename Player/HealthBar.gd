extends CanvasLayer

var HealthSegment = preload("res://Player/HealthSegment.tscn")
var health_segments = []
var max_health = 3
var current_health = 3
var radius = 80

func _ready():
	set_max_health(max_health)

func set_max_health(value):
	max_health = value
	current_health = max_health
	# Remove all existing health segments
	for segment in health_segments:
		segment.queue_free()
	health_segments.clear()
	# Add new health segments
	for i in range(max_health):
		var segment = HealthSegment.instance()
		add_child(segment)
		# Calculate the points for the segment's triangle
		var points = [Vector2.ZERO]
		var angle1 = i * 2 * PI / max_health
		var angle2 = (i + 1) * 2 * PI / max_health
		var point1 = Vector2(cos(angle1), sin(angle1)) * radius
		var point2 = Vector2(cos(angle2), sin(angle2)) * radius
		points.append(point1)
		points.append(point2)
		segment.polygon = points
		health_segments.append(segment)
	update_health()

func take_damage(damage):
	current_health -= damage
	update_health()

func heal_damage(heal):
	current_health += heal
	if current_health > max_health:
		current_health = max_health
	update_health()

func update_health():
	# Update the color of the health segments based on current health
	for i in range(max_health):
		if i < current_health:
			health_segments[i].set_active(true)
		else:
			health_segments[i].set_active(false)
