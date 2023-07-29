extends Panel

var normal_scale = Vector2(1, 1)
var hover_scale = Vector2(1.2, 1.2)
var jiggle_scale = Vector2(0.9, 0.9)
onready var tween: Tween = get_node("Tween")
var clicked := false


func _ready():
	set_rarity(3)
	set_text("This is test text for a card, lmk how it goes!")
#	self.rect_pivot_offset = self.get_rect().size / 2


func _on_Card_mouse_entered():
	tween.interpolate_property(self, "rect_scale", self.rect_scale, hover_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_mouse_exited():
	tween.interpolate_property(self, "rect_scale", self.rect_scale, normal_scale, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		print("Card clicked!")
		bounce()
		clicked = true
		for card in get_parent().get_children():
			if card != self and card.has_method("dissapear"):
				card.disappear()
		apply_effect()
		Global.game_paused = false

func bounce():
	var transparent = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0)
	tween.interpolate_property(self, "rect_scale", self.rect_scale, jiggle_scale, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale", jiggle_scale, Vector2(1.5,1.5), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.interpolate_property(self, "modulate", self.modulate, transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func disappear():
	tween.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.start()

func appear():
	visible = true
#	tween.interpolate_property(self, "rect_scale", Vector2(0,0), normal_scale, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
#	tween.start()
	pass

func _on_Tween_tween_all_completed():
	# Check if bounce() was the function that triggered the signal
	if clicked:
		# Call parent's finished() method
#		self.get_parent().finished()
		# Reset the flag
		clicked  = false


#----------------------------------------------------------------------------------------

func set_rarity(rarity: int) -> void:
	var color : Color
	match rarity:
		1: # common
			color = Color("cea8a8a8") # light grey
		2: # rare
			color = Color("ce3d8fa7") # light blue
		3: # legendary
			color = Color("cee9d849") # gold
		4: # ultra
			color = Color("ceff3c28") # red
		_:
			print("Invalid rarity value")
	
	var style_box = get_stylebox("panel")
	style_box.bg_color = color


func set_text(text: String) -> void:
	get_node("VBoxContainer/Description").bbcode_text = "[center]" + text + "[/center]"


#-----------------------------------------------------------------------------

var title = ""
var text = ""
var rarity = ""
var type = ""
var effect = ""

func load_data(data):
	title = data["title"]
	text = data["text"]
	rarity = data["rarity"]
	type = data["type"]
	effect = data["effect"]

func apply_effect(player):
	match effect:
		"double_damage":
			player.damage *= 2
		// More effects...
