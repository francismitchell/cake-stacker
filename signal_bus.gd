extends Node

signal open_shop_card_processed
signal source_card_purchased
signal card_sold(card_data: CardData)


func await_ingredient_created(ingredient: IngredientData.IngredientType) -> void:
	var ingredient_created: IngredientData.IngredientType = IngredientData.IngredientType.NONE
	while ingredient_created != ingredient:
		ingredient_created = await RecipeManager.ingredient_created


func await_ingredient_sold(ingredient: IngredientData.IngredientType) -> void:
	var ingredient_sold: IngredientData.IngredientType = IngredientData.IngredientType.NONE
	var card_sold: CardData = await SignalBus.card_sold
	while card_sold.card_type != CardData.CardType.INGREDIENT or card_sold.ingredient_type != ingredient:
		card_sold = await SignalBus.card_sold
