extends Area2D

# Configurable variables
var speed: float = 500.0
var size: float = 1.0
var direction: Vector2 = Vector2()
var damage = 50
var knockback_force = 1500


var bullet_owner = null

# State variables
var velocity: Vector2 = Vector2()


func _ready():
	# Set the size of the bullet
	get_node("ColorRect").rect_scale = Vector2(size, size)
	get_node("CollisionShape2D").scale = Vector2(size, size)

	# Set the velocity of the bullet
	velocity = direction.normalized() * speed

func _process(delta):
	# Move the bullet
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if body.has_node("Health"):
		var health_module = body.get_node("Health")
		if !health_module.dead:
			health_module.hit(damage, knockback_force, self)
	queue_free()
