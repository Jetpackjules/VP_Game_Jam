extends Area2D

# Configurable variables
var speed: float
var size: float = 1.0
var direction: Vector2 = Vector2()
var damage := 50
var knockback_force = 1500
var boomerang: bool = true
var boomerang_distance: float = 500.0  # The distance at which the bullet will boomerang

var bullet_owner = null

# State variables
var velocity: Vector2 = Vector2()


# Modifiers
var modifiers = {}

func _ready():
	# Set the size of the bullet
	get_node("ColorRect").rect_scale = Vector2(size, size)
	get_node("CollisionShape2D").scale = Vector2(size, size)

	# Set the velocity of the bullet
	velocity = direction.normalized() * speed



	# Set up modifiers
	if boomerang:
		modifiers["boomerang"] = true

func _process(delta):
	# Move the bullet 
	position += velocity * delta
	rotation = velocity.angle()


	# Apply modifiers
	for modifier in modifiers.keys():
		match modifier:
			"boomerang":
				var start_position = Global.player.global_position
				if global_position.distance_to(start_position) >= boomerang_distance:
					# Gradually turn the bullet around
					var target_direction = (start_position - global_position).normalized()
					velocity = velocity.linear_interpolate(target_direction * speed, 0.15)
					if global_position.distance_to(start_position) <= 50.0:  # Bullet has returned to player
						queue_free()

func _on_Bullet_body_entered(body):
	if body.has_node("Health"):
		var health_module = body.get_node("Health")
		if !health_module.dead:
			health_module.hit(damage, knockback_force, velocity)
	queue_free()

func set_boomerang(value):
	boomerang = value
	if boomerang:
		modifiers["boomerang"] = true
	else:
		modifiers.erase("boomerang")
