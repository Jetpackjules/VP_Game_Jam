extends HBoxContainer

var tween: Tween
var offscreen_position := Vector2(0, -300)  # Adjust as needed
var onscreen_position := Vector2(0, 0)
var hidden := false
var card_scenes_dir := "res://Cards/"  # Set your path
var card_scenes = []
onready var player = get_node("../Player")

func _input(event):
	if Input.is_action_just_pressed("cards_toggle"):
		show_random_cards()
		Global.game_paused = !Global.game_paused

func _ready():
	get_cards()

	
#func toggle():
#	if hidden:
#		show_cards()
#	else:
#		hide_cards()


func hide_cards():
	hidden = true
	for card in get_children():
		card.disappear()

func finished():
	for card in get_children():
		card.queue_free()
	pass

func get_cards():
	var dir = Directory.new()
	if dir.open(card_scenes_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):  # check if it's a scene file
				card_scenes.append(card_scenes_dir + file_name)
			file_name = dir.get_next()

	

func show_random_cards():
	for i in range(3):  # select three random cards
		var random_card_scene = load(card_scenes[randi() % card_scenes.size()]).instance()
		self.add_child(random_card_scene)
		random_card_scene.call_deferred("appear")  # Delay call until after current frame

	hidden = false
	
#	for card in get_children():
#		card.appear()
