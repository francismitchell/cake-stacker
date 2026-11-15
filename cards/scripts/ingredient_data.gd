@tool
class_name IngredientData
extends CardData

enum IngredientType {
	NONE, 
	FAILED_RECIPE, 
	BUTTER, 
	SUGAR, 
	EGG, 
	FLOUR, 
	STRAWBERRY, 
	JAM, 
	BASIC_SPONGE, 
	VICTORIA_SPONGE, 
	CAKE, 
	ICING
	}
enum IngredientQuality {NONE, SILVER, GOLD, PLATINUM}

const ingredient_name_dict: Dictionary[IngredientType, String] = {
	IngredientType.NONE: "None",
	IngredientType.FAILED_RECIPE: "Sludge",
	IngredientType.BUTTER: "Butter",
	IngredientType.SUGAR: "Sugar",
	IngredientType.EGG: "Egg",
	IngredientType.FLOUR: "Flour",
	IngredientType.STRAWBERRY: "Strawberry",
	IngredientType.JAM: "Jam",
	IngredientType.BASIC_SPONGE: "Sponge",
	IngredientType.VICTORIA_SPONGE: "Victoria Sponge",
	IngredientType.CAKE: "Cake",
	IngredientType.ICING: "Icing"
}
const ingredient_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://cards/images/missing_tex.png"),
	IngredientType.FAILED_RECIPE: preload("res://cards/images/sludge.png"),
	IngredientType.BUTTER: preload("res://cards/images/missing_tex.png"),
	IngredientType.SUGAR: preload("res://cards/images/missing_tex.png"),
	IngredientType.EGG: preload("res://cards/images/egg.png"),
	IngredientType.FLOUR: preload("res://cards/images/missing_tex.png"),
	IngredientType.STRAWBERRY: preload("res://cards/images/missing_tex.png"),
	IngredientType.JAM: preload("res://cards/images/missing_tex.png"),
	IngredientType.BASIC_SPONGE: preload("res://cards/images/cooked sponge.png"),
	IngredientType.VICTORIA_SPONGE: preload("res://cards/images/missing_tex.png"),
	IngredientType.CAKE: preload("res://cards/images/cake.png"),
	IngredientType.ICING: preload("res://cards/images/missing_tex.png")
}
const ingredient_quality_texture_dict: Dictionary[IngredientQuality, Texture2D] = {
	IngredientQuality.NONE: null,
	IngredientQuality.SILVER: preload("res://cards/images/stars/silver.png"),
	IngredientQuality.GOLD: preload("res://cards/images/stars/gold.png"),
	IngredientQuality.PLATINUM: preload("res://cards/images/stars/plat.png")
}
@export var ingredient_type: IngredientType = IngredientType.NONE:
	set(value):
		ingredient_type = value
		emit_changed()
var ingredient_quality: IngredientQuality = IngredientQuality.NONE
var ingredient_sell_price: int = 0
