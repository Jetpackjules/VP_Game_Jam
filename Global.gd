# Global.gd
extends Node

var game_paused := false
var camera: Camera2D
var player = null
var Tilemap_Wall = null
var Tilemap_Floor = null
var Nav = null
var line = null


func shake(trauma_in, power = 2):
	camera.trigger_shake(trauma_in, power)

var splatter = load("res://Effects/Splatter.tscn")
#	var random_color = Color(rand_range(0.2, 0.6), rand_range(0.6, 1), rand_range(0, 0.4))  # Random color

func splat(location, direction, scale=1):
	var splat_instance = splatter.instance()
	get_tree().get_current_scene().add_child(splat_instance)
	splat_instance.global_position = location
	splat_instance.rotation = direction.normalized().angle()
	splat_instance.scale = Vector2(scale, scale)  # Apply scale

	var random_color = Color(rand_range(0.6, 1), 0, 0)  # Random red color
	random_color.g = rand_range(0.2, 0.4)  # Random green value
	random_color.b = rand_range(0.2, 0.4)  # Random blue value
	splat_instance.process_material.color = random_color

