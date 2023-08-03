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
			Global.player.weapon.bullet_damage *= 2
		"speed_up_1":
			Global.player.speed *= 1.1
		"speed_up_2":
			Global.player.speed *= 1.2
		"speed_up_3":
			Global.player.speed *= 1.3
		"shrapnel_shot":
			pass
		"double_barrel":
			Global.player.weapon.bullets_fired *= 2
		"plus_bullet_1":
			Global.player.weapon.bullets_fired += 1
		"sniper":
			Global.player.weapon.bullets_fired = 1
			Global.player.weapon.bullet_damage *= 3
			Global.player.weapon.bullet_speed *= 1.5
		"fast_shot_1":
			Global.player.weapon.bullet_speed *= 1.1
		"fast_shot_2":
			Global.player.weapon.bullet_speed *= 1.2
		"fast_shot_3":
			Global.player.weapon.bullet_speed *= 1.3
		_:
			print("UNDEFINED EFFECT!")
			remove_effect()

func remove_effect():
	if effect in Global.active_modifiers:
		Global.active_modifiers.erase(effect)
		match effect:
			"double_damage":
				Global.player.weapon.bullet_damage /= 2
			"speed_up_1":
				Global.player.speed /= 1.1
			"speed_up_2":
				Global.player.speed /= 1.2
			"speed_up_3":
				Global.player.speed /= 1.3
			"shrapnel_shot":
				pass
			"double_barrel":
				Global.player.weapon.bullets_fired /= 2
			"plus_bullet_1":
				Global.player.weapon.bullets_fired -= 1
			"sniper":
				Global.player.weapon.bullets_fired = 1  # Assuming the default value is 1
				Global.player.weapon.bullet_damage /= 3
				Global.player.weapon.bullet_speed /= 1.5
			"fast_shot_1":
				Global.player.weapon.bullet_speed /= 1.1
			"fast_shot_2":
				Global.player.weapon.bullet_speed /= 1.2
			"fast_shot_3":
				Global.player.weapon.bullet_speed /= 1.3
			_:
				print("FAILED TO REMOVE EFFECT!")
				pass
