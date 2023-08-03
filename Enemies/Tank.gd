extends KinematicBody2D

enum State {WANDER, CHARGE, WAIT, RETURN}

onready var movement_module = $Navigation
onready var Player_Tracker = $Player_Tracker

var state = State.WANDER
var start_position = Vector2()
var wait_time = 0
var wander_target = Vector2()

const MAX_WANDER_DISTANCE = 100
const WAIT_TIME = 3
const TILE_TYPE_WALL = 1

onready var body = $Polygon2D2

func _ready():
	
	start_position = global_position

func _physics_process(delta):
	if Global.game_paused:
		return
	
	match state:
		State.WANDER:

			if Player_Tracker.player_visible:
				state = State.CHARGE
			else:
				if position.distance_to(wander_target) < 10:
					wander_target = start_position + Vector2(rand_range(-MAX_WANDER_DISTANCE, MAX_WANDER_DISTANCE), rand_range(-MAX_WANDER_DISTANCE, MAX_WANDER_DISTANCE))
					if Global.Tilemap_Wall.get_cellv(Global.Tilemap_Wall.world_to_map(wander_target)) == TILE_TYPE_WALL:
						wander_target = start_position
				movement_module.move_to_target(wander_target)
		State.CHARGE:
			if Player_Tracker.player_visible:
				movement_module.move_to_target(Global.player.global_position)
			else:
				state = State.WAIT
				wait_time = WAIT_TIME
		State.WAIT:
			wait_time -= delta
			if wait_time <= 0:
				state = State.RETURN
			else:
				movement_module.move_to_target(Player_Tracker.last_known_player_location)
		State.RETURN:
			if Player_Tracker.player_visible:
				state = State.CHARGE
			else:
				if position.distance_to(start_position) < 10:
					state = State.WANDER
				else:
					movement_module.move_to_target(start_position)
