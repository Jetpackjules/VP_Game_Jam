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
		"extra_barrel":
			Global.player.weapon.bullets_fired += 1
			Global.player.weapon.spread *= 1.2
		"shotgun":
			Global.player.weapon.bullet_damage *= 1.2
			Global.player.weapon.bullet_speed *= 0.8
		"impact_shot":
			pass  # Knockback effect not defined in provided code
		"sniper":
			Global.player.weapon.bullets_fired = 1
			Global.player.weapon.bullet_damage *= 3
		"bullet_wings":
			Global.player.weapon.bullet_speed *= 1.2
		"power_shot":
			Global.player.weapon.bullet_size *= 1.2
			Global.player.weapon.bullet_damage *= 1.2
		"close_eye":
			Global.player.weapon.spread *= 0.8
		"sharp_shot":
			pass  # Bullet penetration not defined in provided code
		"quick_fingers":
			Global.player.weapon.reload_time *= 0.8
		"heavy_shot":
			Global.player.weapon.bullet_size *= 1.2
			Global.player.weapon.bullet_speed *= 0.8
		"supplements":
			Global.player.health_counter.set_max_health(Global.player.health_counter.current_health)
		"smol_heal":
			Global.player.health_counter.heal_damage(1)
		"strong_heal":
			Global.player.health_counter.heal_damage(2)
		"super_heal":
			Global.player.health_counter.heal_damage(Global.player.health_counter.current_health*0.5)
		"force_field":
			pass  # Shield effect not defined in provided code
		"hit_frames":
			Global.player.invincibility_duration *= 1.2
		"heavy_recoil":
			pass  # Recoil effect not defined in provided code
		"spiky_skin":
			pass  # Contact damage not defined in provided code
		"cardio":
			Global.player.speed *= 1.1
		"run_away":
			pass  # Speed boost after damage not defined in provided code
		"homing_shot":
			pass  # Bullet curving not defined in provided code
		"boomerang_shot":
			pass  # Bullet return not defined in provided code
		"strong_bullet":
			pass
			Global.player.weapon.bullet_damage *= 0.75  # Assuming bullet damage increases over time elsewhere
		"bulky_bullet":
			pass
			Global.player.weapon.bullet_damage *= 1.5  # Assuming bullet damage decreases over time elsewhere
		"grow_bullets":
			pass  # Bullet growth not defined in provided code
		_:
			print("UNDEFINED EFFECT!")
			remove_effect()

func remove_effect():
	if effect in Global.active_modifiers:
		Global.active_modifiers.erase(effect)
		match effect:
			"extra_barrel":
				Global.player.weapon.bullets_fired -= 1
				Global.player.weapon.spread /= 1.2
			"shotgun":
				Global.player.weapon.bullet_damage /= 1.2
				Global.player.weapon.bullet_speed /= 0.8
			"impact_shot":
				pass
			"sniper":
				Global.player.weapon.bullets_fired = 1  # Assuming the default value is 1
				Global.player.weapon.bullet_damage /= 3
			"bullet_wings":
				Global.player.weapon.bullet_speed /= 1.2
			"power_shot":
				Global.player.weapon.bullet_size /= 1.2
				Global.player.weapon.bullet_damage /= 1.2
			"close_eye":
				Global.player.weapon.spread /= 0.8
			"sharp_shot":
				pass
			"quick_fingers":
				Global.player.weapon.reload_rate /= 0.8
			"heavy_shot":
				Global.player.weapon.bullet_size /= 1.2
				Global.player.weapon.bullet_speed /= 0.8
			"supplements":
				pass # Shouldnt be able to remove
#				Global.player.health.max_health -= 1
			"smol_heal":
				pass  # No need to remove healing effect
			"strong_heal":
				pass  # No need to remove healing effect
			"super_heal":
				pass  # No need to remove healing effect
			"force_field":
				pass
			"hit_frames":
				Global.player.invincibility_duration /= 1.2
			"heavy_recoil":
				pass
			"spiky_skin":
				pass
			"cardio":
				Global.player.speed /= 1.1
			"run_away":
				pass
			"homing_shot":
				pass
			"boomerang_shot":
				pass
			"strong_bullet":
				Global.player.weapon.bullet_damage /= 0.75
			"bulky_bullet":
				Global.player.weapon.bullet_damage /= 1.5
			"grow_bullets":
				pass
			_:
				print("FAILED TO REMOVE EFFECT!")
				pass
