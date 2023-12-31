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

var effect_values = {
	"increase_swarmer_speed": 0.35,
	"more_sniper_damage": 1,
	"increase_tank_health": 0.2,
	# ... Add other effects here ...
}

func apply_effect():
	var modifier_value = effect_values.get(effect, null)
	if modifier_value:
		if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
			Global.Enemy_spawner.active_enemy_modifiers[effect] += modifier_value
		else:
			Global.Enemy_spawner.active_enemy_modifiers[effect] = modifier_value





#func apply_effect():
#	# Handle enemy effects
#	var test = Global.Enemy_spawner.active_enemy_modifiers
#	match effect:
#		"increase_swarmer_speed":
#			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
#				Global.Enemy_spawner.active_enemy_modifiers[effect] += 0.35
#			else:
#				Global.Enemy_spawner.active_enemy_modifiers[effect] = 0.35
#		"more_sniper_damage":
#			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
#				Global.Enemy_spawner.active_enemy_modifiers[effect] += 1
#			else:
#				Global.Enemy_spawner.active_enemy_modifiers[effect] = 1
#			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
#				Global.Enemy_spawner.active_enemy_modifiers[effect] += 0.3
#			else:
#				Global.Enemy_spawner.active_enemy_modifiers[effect] = 0.3
#		"increase_tank_health":
#			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
#				Global.Enemy_spawner.active_enemy_modifiers[effect] += 0.2
#			else:
#				Global.Enemy_spawner.active_enemy_modifiers[effect] = 0.2
#		# ... Add other enemy effects here ...
#
#	# Handle level effects
#	match effect:
#		"add_1_enemy":
#			Global.Enemy_spawner.total_enemies += 1
#		"add_2_enemies":
#			Global.Enemy_spawner.total_enemies += 2
#		"add_3_enemies":
#			Global.Enemy_spawner.total_enemies += 3
#		"shrink_level":
#			Global.Level_Manager.level_iterations *= 0.8
#		# ... Add other level effects here ...
#
#
#func remove_effect():
#	# If the effect is active, remove it
#	if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
#		Global.Enemy_spawner.active_enemy_modifiers.erase(effect)
