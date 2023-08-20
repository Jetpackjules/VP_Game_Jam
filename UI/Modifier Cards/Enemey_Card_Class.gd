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
	# Handle enemy effects
	match effect:
		"increase_enemy_armor":
			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
				Global.Enemy_spawner.active_enemy_modifiers[effect] += 10
			else:
				Global.Enemy_spawner.active_enemy_modifiers[effect] = 10
		"increase_swarmer_speed":
			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
				Global.Enemy_spawner.active_enemy_modifiers[effect] += 0.5
			else:
				Global.Enemy_spawner.active_enemy_modifiers[effect] = 0.5
		"increase_sniper_accuracy":
			if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
				Global.Enemy_spawner.active_enemy_modifiers[effect] += 0.2
			else:
				Global.Enemy_spawner.active_enemy_modifiers[effect] = 0.2
		# ... Add other enemy effects here ...

	# Handle level effects
	match effect:
		"reduce_level_size":
			Global.LevelGenerator.set_level_size(Global.LevelGenerator.get_level_size() * 0.9)
		"add_1_enemy":
			Global.Enemy_spawner.extra_enemies += 1
		"add_2_enemies":
			Global.Enemy_spawner.extra_enemies += 2
		"add_3_enemies":
			Global.Enemy_spawner.extra_enemies += 3
		"increase_maze_complexity":
			Global.LevelGenerator.increase_maze_complexity(0.2)
		# ... Add other level effects here ...

func remove_effect():
	# If the effect is active, remove it
	if Global.Enemy_spawner.active_enemy_modifiers.has(effect):
		Global.Enemy_spawner.active_enemy_modifiers.erase(effect)
