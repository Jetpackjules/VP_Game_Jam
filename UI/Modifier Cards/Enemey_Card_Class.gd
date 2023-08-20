extends Node

var title = ""
var text = ""
var rarity = ""
var type = ""
var effect = ""

func load_data(data):
	title = data["title"].to_upper()
	text = data["text"]
	rarity = data["rarity"]
	type = data["type"]
	effect = data["effect"]


func apply_effect():
	Global.active_modifiers.append(effect)
	match effect:
		_:
			print("UNDEFINED EFFECT!")
			remove_effect()

func remove_effect():
	if effect in Global.active_modifiers:
		Global.active_modifiers.erase(effect)
		match effect:
			_:
				print("FAILED TO REMOVE EFFECT!")
				pass
