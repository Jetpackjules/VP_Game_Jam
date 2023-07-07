extends RayCast2D

var player_visible := false
onready var player: KinematicBody2D = Global.player

var last_known_player_location: Vector2

func _physics_process(delta):
	cast_to = Global.player.global_position - global_position
	force_raycast_update()
	if get_collider() == player:
		player_visible = true
		last_known_player_location = player.global_position
	else:
		player_visible = false
