extends Node2D


export var projectile_scene = preload("res://Projectiles/Basic/Projectile.tscn")
export var projectile_speed: float = 900.0
export var projectile_size: Vector2 = Vector2(1, 1)
export var amount_emitted: int = 1

export var fan_angle: float = 360.0
export var origin_angle: float = 0.0
export var firing_interval: float = 1.0

var emit_timer = Timer.new()

func _ready():
	# Add the timer as a child of this node and set it up
	add_child(emit_timer)
	emit_timer.set_wait_time(1.0)  # emit every 1.0 seconds, adjust as needed
	emit_timer.set_one_shot(false)  # repeat the timer
	emit_timer.connect("timeout", self, "_on_emit_timer_timeout")
	emit_timer.start()

func _on_emit_timer_timeout():
	emit_projectiles()

func set_interval(input_interval):
	firing_interval = input_interval
	emit_timer.wait_time = firing_interval

func _process(delta):
	if Input.is_action_just_pressed("ui_fire"):
		emit_projectiles()

#export var fan_angle: float = 360.0
#export var origin_angle: float = 0.0

func emit_projectiles():
	var angle_step = deg2rad(fan_angle) / max(amount_emitted, 1)
	var start_angle = rotation + deg2rad(origin_angle+90) - deg2rad(fan_angle) / 2

	for i in range(amount_emitted):
		var projectile = projectile_scene.instance()
		projectile.global_position = global_position
		projectile.set_size(projectile_size)
		var angle = start_angle + i * angle_step
		projectile.set_velocity(Vector2(cos(angle), sin(angle)) * projectile_speed)
		projectile.rotation = projectile.velocity.angle() + deg2rad(90)
		
		get_tree().root.add_child(projectile)
