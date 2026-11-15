@tool
class_name CardData
extends Resource

enum CardType {BAKER, INGREDIENT, INGREDIENT_SOURCE, SHOP, SELL}

var card_name: String = ""
@export var card_type: CardType = CardType.INGREDIENT:
	set(value):
		card_type = value
		if card_type == CardType.BAKER: 
			num_bakers += 1
		emit_changed()
static var num_bakers: int = 0


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if card_type == CardType.BAKER:
			num_bakers -= 1
