extends ColorRect

const SHOP_PANEL_Z_INDEX: int = 500

var money: int = 0:
	set(value):
		money = value
		$MarginContainer/MoneyLabel.text = "£" + str(money)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop.z_index = SHOP_PANEL_Z_INDEX
	$Shop/ClickBlockerArea2D.z_index = SHOP_PANEL_Z_INDEX
	# setup proper object picking for cards
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
	SignalBus.open_shop_card_processed.connect(_on_open_shop_card_processed)
	SignalBus.source_card_purchased.connect(_on_source_card_purchased)
	SignalBus.baker_card_purchased.connect(_on_baker_card_purchased)
	SignalBus.courier_pair_purchased.connect(_on_courier_pair_purchased)
	SignalBus.cake_stand_card_purchased.connect(_on_cake_stand_card_purchased)
	SignalBus.card_sold.connect(_on_card_sold)
	run_tutorial()


func _on_open_shop_card_processed() -> void:
	$Shop.visible = not $Shop.visible


func _on_source_card_purchased(ingredient_type: IngredientData.IngredientType, from_global_position: Vector2) -> void:
	var new_card: Card = Card.create_source_card(ingredient_type)
	new_card.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	# hard coded image half sizes
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Cards.add_child(new_card)
	$Shop.hide()


func _on_baker_card_purchased(from_global_position: Vector2) -> void:
	var new_card: Card = Card.create_baker_card()
	new_card.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Cards.add_child(new_card)
	$Shop.hide()


func _on_courier_pair_purchased(from_global_position: Vector2) -> void:
	var courier_pair: Node2D = Card.create_courier_pair()
	courier_pair.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	create_tween().tween_property(courier_pair, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Couriers.add_child(courier_pair)
	$Shop.hide()


func _on_cake_stand_card_purchased(from_global_position: Vector2) -> void:
	var new_card: Card = Card.create_cake_stand_card()
	new_card.global_position = from_global_position
	var target_position = from_global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	$Cards.add_child(new_card)
	$Shop.hide()


func _on_card_sold(card_data: CardData) -> void:
	var sell_amount: int = 0
	if card_data is IngredientData:
		if IngredientData.ingredient_sell_price.has(card_data.ingredient_type):
			sell_amount = IngredientData.ingredient_sell_price[card_data.ingredient_type]
	SignalBus.money += sell_amount
	money = SignalBus.money


func run_tutorial() -> void:
	$Cards/ShopCard.hide()
	$Cards/SellCard.hide()
	$MarginContainer/MoneyLabel.hide()
	# spawn in a baker card and a flour source card
	var baker: Card = Card.create_baker_card()
	baker.global_position = get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0))
	$Cards.add_child(baker)
	await add_card(Card.create_source_card(IngredientData.IngredientType.FLOUR), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0))).card_processed
	add_card(Card.create_source_card(IngredientData.IngredientType.EGG), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0)))
	add_card(Card.create_source_card(IngredientData.IngredientType.SUGAR), get_viewport().get_visible_rect().size / 2.0 + Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0)))
	await SignalBus.await_ingredient_created(IngredientData.IngredientType.GENOISE)
	$Cards/ShopCard.show()
	await SignalBus.await_ingredient_created(IngredientData.IngredientType.SWISS_ROLL)
	$Cards/SellCard.show()
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.SWISS_ROLL)
	$MarginContainer/MoneyLabel.show()


func add_card(card: Card, card_global_position: Vector2) -> Card:
	card.global_position = card_global_position
	$Cards.add_child(card)
	return card
