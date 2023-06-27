extends TextureProgress

var tween = Tween.new()


var original_pos = self.rect_position

func _ready():
	self.add_child(tween)
	randomize()
	
func set_health(new_health):
	start_animations(value-new_health)
	value = new_health

func start_animations(amount):
	# Calculate the shake intensity based on the score increase
	var shake_intensity = amount * 0.1

#	# Cancel any ongoing animations
#	tween.stop_all()

	# Shake along the x and y axes
	for i in range(3):
		var delay = i * 0.05
		var offset = Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
		tween.interpolate_property(self, "rect_position", self.rect_position, self.rect_position + offset, 0.056, Tween.TRANS_LINEAR, delay)
		tween.interpolate_property(self, "rect_position", self.rect_position + offset, original_pos, 0.25, Tween.TRANS_LINEAR, delay + 0.05)

	# Start the tween
	tween.start()


