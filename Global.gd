# Global.gd
extends Node

var game_paused := false
var camera: Camera2D
var player = null
var Tilemap_Wall = null

func shake(trauma_in, power = 2):
	camera.trigger_shake(trauma_in, power)

var splatter = load("res://Effects/Splatter.tscn")

func splat(location, direction):
	var splat_instance = splatter.instance()
	get_tree().get_current_scene().add_child(splat_instance)
	splat_instance.global_position = location
	splat_instance.rotation = direction.normalized().angle()
#	var random_color = Color(rand_range(0.2, 0.6), rand_range(0.6, 1), rand_range(0, 0.4))  # Random color
	var random_color = Color(rand_range(0.6, 1), rand_range(0.2, 0.4), rand_range(0, 0.4))  # Random color
	splat_instance.process_material.color = random_color
#	print("SPLAT AT: ", location)
