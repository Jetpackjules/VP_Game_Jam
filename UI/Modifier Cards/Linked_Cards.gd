	extends Control

var normal_height = 600
var hover_height = 458  
var unravel_height = 1100

var finished = false
var selected = false

onready var tween = get_node("Tween")

var cards = []

func set_player_card(card: Node):
	get_node("Card_Top").set_card(card)
	cards.append(card)

func set_enemy_card(card: Node):
	get_node("Card_Bottom").set_card(card)
	cards.append(card)


func _on_Linked_Cards_mouse_entered():
	print("MOUSE ENTERED!")
	tween.interpolate_property(self, "rect_size:y", rect_size.y, hover_height, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Linked_Cards_mouse_exited():
	tween.interpolate_property(self, "rect_size:y", rect_size.y, normal_height, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func unravel():
	mouse_filter = 2
	finished = true
	tween.interpolate_property(self, "rect_size:y", rect_size.y, unravel_height, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	
	var transparent = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0)
	tween.interpolate_property(self, "modulate", self.modulate, transparent, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Linked_Cards_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		mouse_filter = 2
		for card in cards:
			card.apply_effect()
		
		rect_pivot_offset = rect_size/2
		var transparent = Color(self.modulate.r, self.modulate.g, self.modulate.b, 0)
		tween.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0.9, 0.9), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property(self, "rect_scale", Vector2(0.9, 0.9), Vector2(1.5,1.5), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
		tween.interpolate_property(self, "modulate", self.modulate, transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		selected = true
		get_parent().finished(self)


func _on_Tween_tween_all_completed():
	if selected:
		get_parent().done()
		
