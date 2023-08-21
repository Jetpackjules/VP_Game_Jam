extends HBoxContainer

var offscreen_position := Vector2(0, -300)  # Adjust as needed
var onscreen_position := Vector2(0, 0)
var hidden := false
onready var player = Global.player
onready var Selection_Background = get_node("../Selection_Background")

var player_cards = []
var enemy_cards = []
var offered_cards = []
var Card = preload("res://UI/Modifier Cards/Card_Class.gd")
var Enemy_Card = preload("res://UI/Modifier Cards/Enemy_Card_Class.gd")
var Card_Container = preload("res://UI/Modifier Cards/card_connector.tscn")


func _ready():
	Global.card_selection = self
	var data = load_card_data("res://UI/Modifier Cards/Modifier_Index.json")
	var enemy_data = load_card_data("res://UI/Modifier Cards/Enemy_Modifier_Index.json")
	for card_data in data:
		var card = Card.new()
		card.load_data(card_data)
		player_cards.append(card)
	
	for card_data in enemy_data:
		var enemy_card = Enemy_Card.new()
		enemy_card.load_data(card_data)
		enemy_cards.append(enemy_card)

func _input(event):
	if Input.is_action_just_pressed("cards_toggle"):
		offer_cards()

func offer_cards():
	Global.pause()
	
	for _i in range(3):
		var player_card = pick_card_random(player_cards)
		var enemy_card = pick_card_random(enemy_cards)
		if player_card and enemy_card:
			var card_container = Card_Container.instance()
			card_container.set_player_card(player_card)
			card_container.set_enemy_card(enemy_card)
			add_child(card_container)
	offered_cards.clear()

func load_card_data(path):
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	var data = JSON.parse(text).result
	file.close()
	return data

func pick_card_random(card_list = player_cards, rarity = null, type = null):
	if rarity == null:
		rarity = pick_rarity()
		
	var possible_cards = []
	for card in card_list:
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


func finished(selected_linked_card):
	for linked_card in get_children():
		if linked_card != selected_linked_card:
			linked_card.unravel()


func done():
	for linked_card in get_children():
		linked_card.queue_free()
	Global.resume()


