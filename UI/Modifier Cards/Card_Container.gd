extends PanelContainer

var normal_scale = Vector2(1, 1)
var hover_scale = Vector2(1.2, 1.2)
var jiggle_scale = Vector2(0.9, 0.9)
onready var tween: Tween = get_node("Tween")
var clicked := false


#func _ready():
#	set_title("Thin Bullets 1")
#	set_text("Fired bullets move faster")
#	set_rarity("rare")
#	set_text("This is test text for a card, lmk how it goes!")
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
		Global.resume()

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
		queue_free()


func apply_effect():
	if Attatched_Card:
		Attatched_Card.apply_effect()


#----------------------------------------------------------------------------------------

var Attatched_Card: Node

func set_rarity(rarity: String) -> void:
	var color : Color
	match rarity:
		"common": # common
			color = Color("cea8a8a8") # light grey
		"rare": # rare
			color = Color("ce3d8fa7") # light blue
		"legendary": # legendary
			color = Color("cee9d849") # gold
		"ultra": # ultra
			color = Color("ceff3c28") # red
		_:
			print("Invalid rarity value")
			breakpoint
	
	var style_box = get_stylebox("panel")
	style_box.bg_color = color


func set_text(text: String) -> void:
	var desc = get_node("VBoxContainer/VBoxContainer/Description")
	desc.bbcode_text = "[center]" + text + "[/center]"
	pass

func set_title(title: String) -> void:
	get_node("VBoxContainer/Title").text = title

#var effect: String = "undefined"
#var type: String = "undefined"
func set_card(Card: Node):
	Attatched_Card = Card
	set_rarity(Attatched_Card.rarity)
	set_text(Attatched_Card.text)
	set_title(Attatched_Card.title)
	
#	type = Card.type
	
#-----------------------------------------------------------------------------
