@tool
class_name CardData
extends Resource

enum CardType {BAKER, INGREDIENT, INGREDIENT_SOURCE, SHOP, SELL}

var card_name: String = ""
@export var card_type: CardType = CardType.INGREDIENT:
	set(value):
		card_type = value
		emit_changed()
