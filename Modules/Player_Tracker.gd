extends RayCast2D

var player_visible := false
onready var player = Global.player

func _physics_process(delta):
	cast_to = Global.player.global_position - global_position
	force_raycast_update()
	player_visible = (get_collider() == player)
