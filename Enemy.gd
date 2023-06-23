extends RigidBody2D

export var speed = 20
export var health = 100.0
var player = null
onready var health_bar = get_node("HealthBar_container/HealthBar")
onready var health_bar_container = get_node("HealthBar_container")

func _ready():
	player = get_node("/root/Main/Player")  # Update with your player node's path
	health_bar.max_value = health
	health_bar.value = health


func _physics_process(delta):
	health_bar_container.global_rotation_degrees = 0.0
	var direction = Vector2.ZERO
	if player != null:
		direction = (player.global_position - global_position).normalized()
	apply_central_impulse(direction * speed)

func hit(damage):
	health -= damage
	health_bar.visible = true
	health_bar.value = health
	if health <= 0:
		die()

func die():
	player.enemies.erase(self)
	if player.closest_enemy == self:
		player.closest_enemy = null
	queue_free()
