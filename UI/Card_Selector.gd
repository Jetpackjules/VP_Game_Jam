extends HBoxContainer

var tween: Tween
var offscreen_position := Vector2(0, -300)  # Adjust as needed
var onscreen_position := Vector2(0, 0)
var hidden := false
var card_scenes_dir := "res://Cards/"  # Set your path
var card_scenes = []
onready var player = get_node("../Player")



func _input(event):
	if Input.is_action_just_pressed("cards_toggle"):
		var cards = pick_two_cards_same_rarity("common")
		if cards:
			var card_container1 = Card_Container.instance()
			card_container1.set_player_card(cards[0])
			add_child(card_container1)

			var card_container2 = Card_Container.instance()
			card_container2.set_enemy_card(cards[1])
			add_child(card_container2)

			print(cards[0].title)
			print(cards[1].title)

			Global.game_paused = !Global.game_paused


var cards = []
var Card = preload("res://UI/Modifier Cards/Card_Class.gd")
var Card_Container = preload("res://UI/Modifier Cards/card_connector.tscn")


func _ready():
	var data = load_card_data("res://UI/Modifier Cards/Modifier_Index.json")
	for card_data in data:
		var card = Card.new()
		card.load_data(card_data)
		cards.append(card)

func load_card_data(path):
	var file = File.new()
	var status = file.open(path, File.READ) == OK
	var text = file.get_as_text()
	var status2 = JSON.parse(text).error
	var data = JSON.parse(text).result
	file.close()
	return data


func pick_card(rarity, type):
	var possible_cards = []
	for card in cards:
		if card.rarity == rarity and card.type == type:
			possible_cards.append(card)
	if possible_cards.size() > 0:
		return possible_cards[randi() % possible_cards.size()]
	else:
		return null


func pick_card_random():
	if cards.size() > 0:
		return cards[randi() % cards.size()]
	else:
		return null

func pick_two_cards_same_rarity(rarity):
	var possible_cards = []
	for card in cards:
		if card.rarity == rarity:
			possible_cards.append(card)
	if possible_cards.size() >= 2:
		var card1 = possible_cards.pop_at(randi() % possible_cards.size())
		var card2 = possible_cards.pop_at(randi() % possible_cards.size())
		return [card1, card2]
	else:
		return null
