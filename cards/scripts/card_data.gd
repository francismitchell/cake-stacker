@tool
class_name CardData
extends Resource

enum CardType {BAKER, INGREDIENT, INGREDIENT_SOURCE, SHOP, SELL, BUY_INGREDIENT_SOURCE, COURIER, DESTINATION, BUY_BAKER_CARD, BUY_COURIER_PAIR, CAKE_STAND, BUY_CAKE_STAND}

var card_name: String = ""
@export var card_type: CardType = CardType.INGREDIENT:
	set(value):
		card_type = value
		emit_changed()
var card_sell_price: int = 0
@export var processable_by_baker: bool = true
