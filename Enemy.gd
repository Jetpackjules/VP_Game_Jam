extends RigidBody2D

export var speed = 20
var player = null

func _ready():
	player = get_node("/root/Main/Player")  # Update with your player node's path

func _physics_process(delta):
	var direction = Vector2.ZERO
	if player != null:
		direction = (player.global_position - global_position).normalized()
	apply_central_impulse(direction * speed)


func hit():
	die()
	
func die():
	player.enemies.erase(self)
	if player.closest_enemy == self:
		player.closest_enemy = null
	queue_free()
