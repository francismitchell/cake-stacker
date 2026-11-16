extends ColorRect

var money: int = 0:
	set(value):
		money = value
		$MarginContainer/MoneyLabel.text = "£" + str(money)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup proper object picking for cards
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
	SignalBus.open_shop_card_processed.connect($Shop.show)
	SignalBus.source_card_purchased.connect(_on_source_card_purchased)
	SignalBus.card_sold.connect(_on_card_sold)
	run_tutorial()

func _on_source_card_purchased(ingredient_type: IngredientData.IngredientType, from_global_position: Vector2) -> void:
	var new_card: Card = Card.create_source_card(ingredient_type)
	new_card.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	# hard coded image half sizes
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Cards.add_child(new_card)
	$Shop.hide()

func _on_card_sold(sell_amount: int) -> void:
	money += sell_amount

func run_tutorial() -> void:
	$Cards/ShopCard.hide()
	$Cards/SellCard.hide()
	$MarginContainer/MoneyLabel.hide()
	# spawn in a baker card and a flour source card
	var baker: Card = Card.create_baker_card()
	baker.global_position = get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0))
	add_child(baker)
	await add_card(Card.create_source_card(IngredientData.IngredientType.FLOUR), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0))).card_processed
	add_card(Card.create_source_card(IngredientData.IngredientType.EGG), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0)))
	add_card(Card.create_source_card(IngredientData.IngredientType.SUGAR), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0)))
	await await_ingredient_created(IngredientData.IngredientType.GENOISE)
	$Cards/ShopCard.show()
	await await_ingredient_created(IngredientData.IngredientType.SWISS_ROLL)
	$Cards/SellCard.show()
	money = 10
	$MarginContainer/MoneyLabel.show()

func await_ingredient_created(ingredient: IngredientData.IngredientType) -> void:
	var ingredient_created: IngredientData.IngredientType = IngredientData.IngredientType.NONE
	while ingredient_created != ingredient:
		ingredient_created = await RecipeManager.ingredient_created

func add_card(card: Card, card_global_position: Vector2) -> Card:
	card.global_position = card_global_position
	add_child(card)
	return card
