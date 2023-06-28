extends Panel

var normal_scale = Vector2(1, 1)
var hover_scale = Vector2(1.2, 1.2)
var jiggle_scale = Vector2(0.9, 0.9)
onready var tween: Tween = get_node("Tween")
var clicked := false


func _ready():
	self.rect_pivot_offset = self.get_rect().size / 2
#	self.rect_scale = Vector2(0,0)  # Start invisible
	# Set the mouse filter to stop (detects) events
	mouse_filter = MOUSE_FILTER_STOP
	set_light_mask(1)

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
			if card != self:
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
		self.get_parent().finished()
		# Reset the flag
		clicked  = false

func apply_effect():
	pass
