extends "res://Weapons/Weapon.gd"

# Shotgun-specific properties
var spread: float = 22.0  # Degrees
var pellets: int = 5

func _ready():
	# Override base properties
	fire_rate = 0.5
	reload_rate = 2.0
	bullet_speed = 1600.0
	bullet_size = 1.5

func _input(event):
	if event.is_action_pressed("ui_fire") and !Global.game_paused:
		fire()

func fire():
	if !can_fire:
		return
	
#	screenshake:
	Global.shake(.1, 1)
	
	for i in range(pellets):
		# Create a bullet and set its properties
		var bullet = Bullet.instance()
		bullet.speed = bullet_speed
		bullet.size = bullet_size

		# Calculate the angle for this pellet with some randomness
		var angle = spread * (randf() - 0.5)

		# Set the bullet's direction and rotation
		var player_rotation = get_parent().facing_rotation
		var bullet_direction = Vector2.RIGHT.rotated(player_rotation + deg2rad(angle))
		bullet.direction = bullet_direction
		bullet.rotation = bullet_direction.angle()

		# Add the bullet to the scene
		get_parent().get_parent().add_child(bullet)

		# Set the bullet's position to the weapon's position
		bullet.global_position = global_position

	can_fire = false

