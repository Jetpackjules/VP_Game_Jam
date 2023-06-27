extends RigidBody2D

export var speed = 20
export var health = 100.0
var player = null
var original_linear_velocity = Vector2.ZERO
var original_angular_velocity = 0
onready var health_bar = get_node("HealthBar_container/HealthBar")
onready var health_bar_container = get_node("HealthBar_container")
onready var hit_anim = get_node("Hit_Anim")

func _ready():
	player = get_node("/root/Main/Player")  # Update with your player node's path
	health_bar.max_value = health
	health_bar.value = health


func _process(delta):
	if Global.game_paused and mode != MODE_STATIC:
		original_linear_velocity = linear_velocity
		original_angular_velocity = angular_velocity
#		linear_velocity = Vector2.ZERO
#		angular_velocity = 0
		mode = MODE_STATIC
	elif !Global.game_paused:
		if mode == MODE_STATIC:
			linear_velocity = original_linear_velocity
			angular_velocity = original_angular_velocity
			mode = MODE_RIGID
		# The rest of your physics process logic goes here
		health_bar_container.global_rotation_degrees = 0.0
		var direction = Vector2.ZERO
		if player != null:
			direction = (player.global_position - global_position).normalized()
		apply_central_impulse(direction * speed)
		
		
		
		
func hit(damage, knockback):
	hit_anim.play("Hit")
	health -= damage
	health_bar.visible = true
	health_bar.value = health
	if health <= 0:
		die()
	else:
		var knockback_direction = (global_position - player.global_position).normalized()
		apply_impulse(Vector2.ZERO, knockback_direction * knockback)


func die():
	player.enemies.erase(self)
	Score.increase_score(10)
	if player.closest_enemy == self:
		player.closest_enemy = null
	queue_free()
