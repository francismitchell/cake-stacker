extends ColorRect

const SOURCE_CARD_SCENE = preload("res://cards/scenes/source_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup proper object picking for cards
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
	SignalBus.open_shop_card_processed.connect($Shop.show)
	SignalBus.source_card_purchased.connect(_on_source_card_purchased)

func _on_source_card_purchased(ingredient_type: IngredientData.IngredientType, from_global_position: Vector2) -> void:
	var new_card: Card = SOURCE_CARD_SCENE.instantiate()
	var card_data: IngredientData = IngredientData.new()
	card_data.card_type = CardData.CardType.INGREDIENT_SOURCE
	card_data.ingredient_type = ingredient_type
	new_card.card_data = card_data
	new_card.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	# hard coded image half sizes
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Cards.add_child(new_card)
	$Shop.hide()
