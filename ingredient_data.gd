@tool
class_name IngredientData
extends CardData

enum IngredientType {NONE, BUTTER, SUGAR, EGG, FLOUR, STRAWBERRY, JAM}
enum IngredientQuality {NONE, BRONZE, SILVER, GOLD}

static var ingredient_name_dict: Dictionary[IngredientType, String] = {
	IngredientType.NONE: "None",
	IngredientType.BUTTER: "Butter",
	IngredientType.SUGAR: "Sugar",
	IngredientType.EGG: "Egg",
	IngredientType.FLOUR: "Flour",
	IngredientType.STRAWBERRY: "Strawberry",
	IngredientType.JAM: "Strawberry jam"
}
static var ingredient_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://icon.svg"),
	IngredientType.BUTTER: preload("res://icon.svg"),
	IngredientType.SUGAR: preload("res://icon.svg"),
	IngredientType.EGG: preload("res://icon.svg"),
	IngredientType.FLOUR: preload("res://cake.png"),
	IngredientType.STRAWBERRY: preload("res://icon.svg"),
	IngredientType.JAM: preload("res://icon.svg")
}
@export var ingredient_type: IngredientType = IngredientType.NONE:
	set(value):
		ingredient_type = value
		emit_changed()
var ingredient_quality: IngredientQuality = IngredientQuality.NONE
var ingredient_sell_price: int = 0
