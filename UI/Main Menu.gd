extends CanvasLayer


func _ready():
	pass

func _on_Start_Button_pressed():
	
	Global.reset_player()
	Global.emit_signal("new_level")
	Global.resume()
	queue_free()

