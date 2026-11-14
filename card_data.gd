@tool
class_name CardData
extends Resource

enum CardType {BAKER, INGREDIENT, INGREDIENT_SOURCE}

var card_name: String = ""
var card_type: CardType = CardType.INGREDIENT:
	set(value):
		card_type = value
		emit_changed()
