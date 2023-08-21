extends Area2D

# Configurable variables
var speed: float
var size: float = 1.0
var direction: Vector2 = Vector2()
var damage := 50
var knockback_force: float 

var boomerang_distance: float = 500.0  # The distance at which the bullet will boomerang (NEED TO MAKE THIS CHANGE DEPENDING ON SPEED ETC!)

var homing_strength = 0.10  # Adjust this value to change how quickly the bullet turns
var target_enemy = null



var bullet_owner = null

# State variables
var velocity: Vector2 = Vector2()


# Over time mods:
var grow_rate: float = 1
var damage_rate: float = 1


# Modifiers
var modifiers: Dictionary
var penetrations: int

onready var sprite = $ColorRect

func apply_visual_effects():
	# If homing, make the bullet more purply
	if modifiers["homing"]:
		sprite.modulate = Color(1, 0.5, 1)  # Purple color

	# If boomerang, add a trail effect (you can expand on this)
	if modifiers["boomerang"]:
		# Assuming you have a Trail node or scene
		pass

	# For damage_rate, adjust the bullet's color intensity
	var damage_intensity = map_value(damage, 0, 1, 1, 0.5)
	sprite.modulate = sprite.modulate.linear_interpolate(Color(1, 0, 0), damage_intensity)  # Red color for damage


# Utility function to map a value from one range to another
func map_value(value, in_min, in_max, out_min, out_max):
	return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


func _ready():
	apply_visual_effects()
	# Set the size of the bullet
	set_size(size)
	# Set the velocity of the bullet
	velocity = direction.normalized() * speed

func set_size(scale):
	get_node("ColorRect").rect_scale = Vector2(scale, scale)
	get_node("CollisionShape2D").scale = Vector2(scale, scale)

func _process(delta):
	# Move the bullet 
	position += velocity * delta
	rotation = velocity.angle()

	# Effects over time
	size *= grow_rate
	set_size(size)
	damage *= damage_rate
	
	print(damage, " <-- dmg")

	# Apply modifiers
	if modifiers["boomerang"]:
		var start_position = Global.player.global_position
		if global_position.distance_to(start_position) >= boomerang_distance:
			# Gradually turn the bullet around
			var target_direction = (start_position - global_position).normalized()
			velocity = velocity.linear_interpolate(target_direction * speed, 0.15)
#			if global_position.distance_to(start_position) <= 50.0:  # Bullet has returned to player
#				queue_free()
	if modifiers["homing"]:
		target_enemy = get_enemy_in_cone()
		if target_enemy:
			var direction_to_enemy = (target_enemy.global_position - global_position).normalized()
			velocity = velocity.linear_interpolate(direction_to_enemy * speed, homing_strength)

func _on_Bullet_body_entered(body):
	if body.has_node("Health"):
		var health_module = body.get_node("Health")
		if !health_module.dead:
			health_module.hit(damage, knockback_force, velocity)
		
		if penetrations <= 0:
			queue_free()
		penetrations -= 1
		
	elif body.is_in_group("wall"):
		queue_free()

func get_enemy_in_cone():
	var enemies = get_tree().get_nodes_in_group("enemies")  # Assuming enemies are in a group named "enemies"
	var bullet_direction = velocity.normalized()
	for enemy in enemies:
		var direction_to_enemy = (enemy.global_position - global_position).normalized()
		var angle_difference = bullet_direction.angle_to(direction_to_enemy)
		if abs(angle_difference) <= deg2rad(35):  # 15 degrees to each side, making a 30-degree cone
			return enemy
	return null
