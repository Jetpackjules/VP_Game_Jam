extends Panel

var normal_scale = Vector2(1, 1)
var hover_scale = Vector2(1.2, 1.2)
var jiggle_scale = Vector2(0.9, 0.9)
var tween: Tween

func _ready():
	# Initialize Tween
	tween = Tween.new()
	self.add_child(tween)

	# Set the mouse filter to stop (detects) events
	mouse_filter = MOUSE_FILTER_STOP

func _on_Card_mouse_entered():
	self.rect_pivot_offset = self.get_rect().size / 2
	tween.interpolate_property(self, "rect_scale", self.rect_scale, hover_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_mouse_exited():
	self.rect_pivot_offset = self.get_rect().size / 2
	tween.interpolate_property(self, "rect_scale", self.rect_scale, normal_scale, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Card_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		print("Card clicked!")
		shrink_and_grow()

func shrink_and_grow():
	tween.interpolate_property(self, "rect_scale", self.rect_scale, jiggle_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale", jiggle_scale, hover_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.start()
