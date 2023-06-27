extends Label

# Current score
var score = 0

# Tween for animations
var tween = Tween.new()

# Original position
var original_pos = Vector2.ZERO

func _ready():
	# Store the original position
	original_pos = self.rect_position

	# Add the tween to the scene
	self.add_child(tween)

	# Initialize the random number generator
	randomize()

#func _process(delta):
#	# Just for testing, increase the score every second
#	if OS.get_ticks_msec() % 1000 < delta * 1000:
#		increase_score(10)

func increase_score(amount):
	# Increase the score
	score += amount

	# Update the label
	self.text = str(score)

	# Start the animations
	start_animations(amount)

func start_animations(amount):
	# Calculate the shake intensity based on the score increase
	var shake_intensity = amount * .7

	# Cancel any ongoing animations
	tween.stop_all()

	# Shake along the x and y axes
	for i in range(3):
		var delay = i * 0.05
		var offset = Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
		tween.interpolate_property(self, "rect_position", self.rect_position, self.rect_position + offset, 0.05, Tween.TRANS_LINEAR, delay)
		tween.interpolate_property(self, "rect_position", self.rect_position + offset, original_pos, 0.05, Tween.TRANS_LINEAR, delay + 0.05)

	# Start the tween
	tween.start()
