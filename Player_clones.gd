extends Node2D


var clones := []
onready var player = get_node("../Player")
onready var camera = get_node("../Camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	clones = get_children()
	pass # Replace with function body.
	var screen_size = get_viewport_rect().size*camera.zoom.x
	


func _process(_delta) -> void:
	for clone in clones:
		clone.position = player.position
		clone.rotation = player.rotation
	pass
