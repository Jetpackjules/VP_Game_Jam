extends Label


func _process(delta):
#	set_text(str(get_parent().get_node("Health").health))
	set_text("FPS " + String(Engine.get_frames_per_second()))
