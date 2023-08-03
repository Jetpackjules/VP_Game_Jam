extends Node2D

func _on_Area2D_body_entered(body):
	if body == Global.player:
		Global.emit_signal("new_level")
		Global.card_selection.offer_cards()
