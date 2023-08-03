extends KinematicBody2D

enum State {CHARGE, WAIT, RETURN}

onready var movement_module = $Navigation
onready var Player_Tracker = $Player_Tracker

var state = State.CHARGE



onready var body = $Polygon2D

func _ready():
	print("IN")

func _physics_process(delta):
	if Global.game_paused:
		return
	
	match state:
		State.CHARGE:
#			if Player_Tracker.player_visible:
			movement_module.move_to_target(Global.player.global_position)
				
