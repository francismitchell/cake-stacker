@tool
class_name CardData
extends Resource

enum CardType {BAKER, INGREDIENT, INGREDIENT_SOURCE, SHOP, SELL, BUY_INGREDIENT_SOURCE, COURIER, DESTINATION, BUY_BAKER_CARD, BUY_COURIER_PAIR}

static var num_bakers: int = 0

var card_name: String = ""
@export var card_type: CardType = CardType.INGREDIENT:
	set(value):
		card_type = value
		if card_type == CardType.BAKER: 
			num_bakers += 1
		emit_changed()
var card_sell_price: int = 0


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if card_type == CardType.BAKER:
			num_bakers -= 1
