extends Node2D

# Configurable variables
var fire_rate: float = 1.0
var reload_rate: float = 1.0
var bullet_speed: float = 1000.0
var bullet_size: float = 1.0
var bullet_damage: float = 10.0


# State variables
var can_fire: bool = true
var fire_timer: float = 0.0  # Added timer

# Bullet scene
var Bullet = preload("res://Weapons/Bullets/Bullet.tscn")

# This method should be overridden by each weapon type
func fire():
	if !can_fire:
		return
	

	
	
	# Create a bullet and set its properties
	var bullet = Bullet.instance()
	bullet.speed = bullet_speed
	bullet.size = bullet_size
	bullet.damage = bullet_damage
	# Set the bullet's direction and rotation
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	bullet.rotation = rotation
	
	bullet.global_position = global_position
	# Add the bullet to the scene
	get_parent().get_parent().add_child(bullet)

	can_fire = false

func _process(delta):
	if !can_fire:
		reload_rate -= delta
		if reload_rate <= 0:
			can_fire = true
			reload_rate = 1.0
#
#	# Fire a bullet once every second
#	fire_timer += delta
#	if fire_timer >= 1.0:
#		fire()
#		fire_timer = 0.0
