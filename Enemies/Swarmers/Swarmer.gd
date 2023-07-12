extends KinematicBody2D

enum State {CHARGE, WAIT, RETURN}

onready var movement_module = $Navigation
onready var Player_Tracker = $Player_Tracker

var state = State.CHARGE



onready var body = $Polygon2D



func _physics_process(delta):
	match state:
		State.CHARGE:
			if Player_Tracker.player_visible:
				movement_module.move_to_target(Player_Tracker.player.global_position)
				
