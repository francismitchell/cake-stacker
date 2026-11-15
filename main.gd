extends ColorRect

const SOURCE_CARD_SCENE = preload("res://cards/scenes/source_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup proper object picking for cards
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
	SignalBus.open_shop_card_processed.connect($Shop.show)
	SignalBus.source_card_purchased.connect(_on_source_card_purchased)

func _on_source_card_purchased(ingredient_type: IngredientData.IngredientType) -> void:
	var new_card: Card = SOURCE_CARD_SCENE.instantiate()
	var card_data: IngredientData = IngredientData.new()
	card_data.card_type = CardData.CardType.INGREDIENT_SOURCE
	card_data.ingredient_type = ingredient_type
	new_card.card_data = card_data
	new_card.global_position = get_viewport().get_visible_rect().size / 2.0
	$Cards.add_child(new_card)
