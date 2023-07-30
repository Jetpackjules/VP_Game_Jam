extends Control

func set_player_card(card: Node):
	get_node("Card_Top").set_card(card)

func set_enemy_card(card: Node):
	get_node("Card_Bottom").set_card(card)
