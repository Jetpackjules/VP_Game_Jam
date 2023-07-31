extends HBoxContainer

var offscreen_position := Vector2(0, -300)  # Adjust as needed
var onscreen_position := Vector2(0, 0)
var hidden := false
onready var player = Global.player
onready var Selection_Background = get_node("../Selection_Background")

var cards = []
var offered_cards = []
var Card = preload("res://UI/Modifier Cards/Card_Class.gd")
var Card_Container = preload("res://UI/Modifier Cards/card_connector.tscn")

func _ready():
	var data = load_card_data("res://UI/Modifier Cards/Modifier_Index.json")
	for card_data in data:
		var card = Card.new()
		card.load_data(card_data)
		cards.append(card)

func _input(event):
	if Input.is_action_just_pressed("cards_toggle"):
		for _i in range(3):
			var card1 = pick_card_random()
			var card2 = pick_card_random()
			if card1 and card2:
				var card_container = Card_Container.instance()
				card_container.set_player_card(card1)
				card_container.set_enemy_card(card2)
				add_child(card_container)
		Global.pause()

		
		offered_cards.clear()

func load_card_data(path):
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	var data = JSON.parse(text).result
	file.close()
	return data

func pick_card_random(rarity = null, type = null):
	if rarity == null:
		rarity = pick_rarity()
		
	var possible_cards = []
	for card in cards:
		if not card in offered_cards and (card.rarity == rarity) and (type == null or card.type == type):
			possible_cards.append(card)
	if possible_cards.size() > 0:
		var chosen_card = possible_cards[randi() % possible_cards.size()]
		offered_cards.append(chosen_card)
		return chosen_card
	else:
		return null

func pick_rarity():
	var rand_num = randf()
	if rand_num < 0.10:
		return "legendary"
	elif rand_num < 0.35:  # 0.10 (previous threshold) + 0.25 (rare odds)
		return "rare"
	else:
		return "common"

