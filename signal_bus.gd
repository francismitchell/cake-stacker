extends Node

signal open_shop_card_processed
signal source_card_purchased(ingredient_type: IngredientData.IngredientType, purchase_position: Vector2)
signal baker_card_purchased(purchase_position: Vector2)
signal courier_pair_purchased(purchase_position: Vector2)
signal cake_stand_card_purchased(purchase_position: Vector2)
signal card_sold(card_data: CardData)
signal shop_visibility_changed(open: bool)

var shop_open: bool = false
var shop_panel: PanelContainer
var money: int = 0

func await_ingredient_created(ingredient: IngredientData.IngredientType) -> void:
	var ingredient_created: IngredientData.IngredientType = IngredientData.IngredientType.NONE
	while ingredient_created != ingredient:
		ingredient_created = await RecipeManager.ingredient_created


func await_ingredient_sold(ingredient: IngredientData.IngredientType) -> void:
	var ingredient_sold: IngredientData.IngredientType = IngredientData.IngredientType.NONE
	var card_sold: CardData = await SignalBus.card_sold
	while card_sold.card_type != CardData.CardType.INGREDIENT or card_sold.ingredient_type != ingredient:
		card_sold = await SignalBus.card_sold


func is_point_in_shop_panel(point: Vector2) -> bool:
	return shop_open and shop_panel != null and shop_panel.get_global_rect().has_point(point)
