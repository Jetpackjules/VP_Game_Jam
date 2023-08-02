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
#
func apply_effect():
	Global.active_modifiers.append(effect)
	match effect:
		"double_damage":
			print("DOUBLEING DAMAGE....")
			# Apply the effect here. For example:
			# player.damage *= 2
			pass
		"extra_jump":
			# Apply the effect here. For example:
			# player.extra_jumps += 1
			pass
		# Add more effects as needed...
		_:
			print("UNDEFINED EFFECT!")
#			breakpoint
			remove_effect()

func remove_effect():
	if effect in Global.active_modifiers:
		Global.active_modifiers.erase(effect)
		match effect:
			"double_damage":
				# Remove the effect here. For example:
				# player.damage /= 2
				pass
			"extra_jump":
				# Remove the effect here. For example:
				# player.extra_jumps -= 1
				pass			
			_:
				print("FAILED TO REMOVE EFFECT!")
				pass
