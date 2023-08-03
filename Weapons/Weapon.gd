extends Node2D

#Useless vars (for now):
var fire_rate: float = 0.3
var fire_timer: float = 0.0 

# Configurable variables
var reload_time: float = 0.2
var bullet_speed: float = 1600.0
var bullet_size: float = 1.3
var bullet_damage: float = 10.0
var spread: float = 14.0  # Degrees
var bullets_fired: int = 1

# State variables
var can_fire: bool = true
var reload_cooldown: float = 0.0

# Bullet scene
var Bullet = preload("res://Weapons/Bullets/Bullet.tscn")

func _physics_process(delta):
	if Input.is_action_pressed("ui_fire") and !Global.game_paused and can_fire:
		fire()

func fire():
	#	screenshake:
	Global.shake(.1, 1)
	
	for i in range(bullets_fired):
		# Create a bullet and set its properties
		var bullet = Bullet.instance()
		bullet.speed = bullet_speed
		bullet.size = bullet_size
		bullet.damage = bullet_damage

		# Calculate the angle for this bullet with some randomness
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


func _process(delta):
	if !can_fire:
		reload_cooldown -= delta
		if reload_cooldown <= 0:
			can_fire = true
			reload_cooldown = reload_time
