extends RigidBody2D

export var speed = 20
export var health = 100.0
var player = null
var original_linear_velocity = Vector2.ZERO
var original_angular_velocity = 0
onready var health_bar = get_node("HealthBar_container/HealthBar")
onready var health_bar_container = get_node("HealthBar_container")
onready var hit_anim = get_node("Hit_Anim")
onready var tween: Tween = get_node("Tween")
var dead := false
onready var sprite = get_node("Icon")
var max_speed := 200


func _ready():
	player = get_node("/root/Main/Player")  # Update with your player node's path
	health_bar.max_value = health
	health_bar.value = health


func _physics_process(delta):
	if Global.game_paused and mode != MODE_STATIC or dead:
		original_linear_velocity = linear_velocity
		original_angular_velocity = angular_velocity
		mode = MODE_STATIC
	elif !Global.game_paused and !dead:
		if mode == MODE_STATIC:
			linear_velocity = original_linear_velocity
			angular_velocity = original_angular_velocity
			mode = MODE_RIGID
		health_bar_container.global_rotation_degrees = 0.0
		var direction = Vector2.ZERO
		if player != null:
			direction = (player.global_position - global_position).normalized()
			self.look_at(player.global_position)  # Make the enemy face the player
		apply_central_impulse(direction * speed)
		# Capping the maximum speed
		if linear_velocity.length() > max_speed:
			linear_velocity = linear_velocity.normalized() * max_speed

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
	dead = true
	player.enemies.erase(self)
	get_parent().get_parent().get_node("Score").increase_score(10)
	if player.closest_enemy == self:
		player.closest_enemy = null
	dissapear()

func _on_Basic_body_entered(body):
	if body == player:
		player.hit(10, global_position)
		print(body)
		die()
	pass # Replace with function body.


func dissapear():
#	self.mode = MODE_STATIC
	# Disable collision mask for layers 1 and 2
	set_collision_mask_bit(0, false)  # Layer indices start at 0, so layer 1 is at index 0
	set_collision_mask_bit(1, false)  # Layer 2 is at index 1

	# Disable collision layer for layers 1 and 2
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, false)
	var transparent = Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 0)
	tween.interpolate_property(sprite, "scale", sprite.scale, sprite.scale*1.8, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.interpolate_property(sprite, "modulate", Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 0.4), transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	if dead:
		queue_free()
