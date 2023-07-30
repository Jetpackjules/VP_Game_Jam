# Global.gd
extends Node

var game_paused := false
var camera: Camera2D
var player: KinematicBody2D = null
var Tilemap_Wall: TileMap = null
var Tilemap_Floor: TileMap = null
var Nav: Navigation2D = null


func shake(trauma_in, power = 2):
	camera.trigger_shake(trauma_in, power)

var splatter := load("res://Effects/Splatter.tscn")

func splat(location, direction, scale=1):
	var splat_instance: Particles2D = splatter.instance()
	get_tree().get_current_scene().add_child(splat_instance)
	splat_instance.global_position = location
	splat_instance.rotation = direction.normalized().angle()
	splat_instance.scale = Vector2(scale, scale)  # Apply scale
	splat_instance.process_material.scale *= clamp(scale, 0.75, 1.25)
	
	var random_color: Color = Color(rand_range(0.6, 1), 0, 0)  # Random red color
	random_color.g = rand_range(0.2, 0.4)  # Random green value
	random_color.b = rand_range(0.2, 0.4)  # Random blue value
	splat_instance.process_material.color = random_color


# ----------------------------------------

var active_modifiers := []
