@tool
extends VBoxContainer

const CARD_POSITION: Vector2 = Vector2(64.0, 98.0)

@onready var card_control: Control = $CardControl
@export var card_type: CardData.CardType = CardData.CardType.INGREDIENT_SOURCE:
	set(value):
		card_type = value
		if is_node_ready():
			_update_item()
@export var ingredient_type: IngredientData.IngredientType = IngredientData.IngredientType.NONE:
	set(value):
		ingredient_type = value
		if is_node_ready():
			_update_item()
var item_price:
	set(value):
		item_price = value
		if is_node_ready():
			$Label.text = str("£", item_price)
@export var locked: bool = false:
	set(value):
		locked = value
		if not is_node_ready(): return
		if locked: _lock_card() 
		else: _unlock_card()



func _lock_card() -> void:
	$Label.text = "???"
	if card_type == CardData.CardType.BUY_COURIER_PAIR:
		var courier_pair: CourierPair = card_control.get_node("CourierCardPair")
		courier_pair.courier_card.card_texture.texture = load("res://cards/images/missing_tex.png")
		courier_pair.destination_card.card_texture.texture = load("res://cards/images/missing_tex.png")
	else:
		var card: Card = card_control.get_node("Card")
		card.card_texture.texture = load("res://cards/images/missing_tex.png")

func _unlock_card() -> void:
	$Label.text = str("£", item_price)
	if card_type == CardData.CardType.BUY_COURIER_PAIR: return
	var card: Card = card_control.get_node("Card")
	card.initialise_card_visuals()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_item()


func _update_item() -> void:
	item_price = CardData.card_buy_price[card_type]
	if card_type == CardData.CardType.BUY_COURIER_PAIR: return
		#var courier_pair: CourierPair = load(Card.COURIER_PAIR_SCENE_PATH).instantiate()
		#courier_pair.position = CARD_POSITION
		#card_control.add_child(courier_pair)
		#courier_pair.courier_card.card_data.card_type = CardData.CardType.BUY_COURIER_PAIR
		#courier_pair.destination_card.card_data.card_type = CardData.CardType.BUY_COURIER_PAIR
		#courier_pair.courier_card.reassign_z_indices()
		#courier_pair.destination_card.reassign_z_indices()
	for child in card_control.get_children():
		child.queue_free()
	var card: Card = load(Card.CARD_SCENE_PATH).instantiate()
	card.card_data = card.card_data.duplicate()
	card.card_data.card_type = card_type
	if card.card_data is IngredientData:
		card.card_data.ingredient_type = ingredient_type
	card.position = CARD_POSITION
	card_control.add_child(card)
	if locked: _lock_card()
	else: _unlock_card()
