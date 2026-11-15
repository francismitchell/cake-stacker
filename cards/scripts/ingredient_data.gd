@tool
class_name IngredientData
extends CardData

enum IngredientType {NONE, FAILED_RECIPE, BUTTER, SUGAR, EGG, FLOUR, STRAWBERRY, JAM, BASIC_SPONGE, VICTORIA_SPONGE}
enum IngredientQuality {NONE, BRONZE, SILVER, GOLD}

static var ingredient_name_dict: Dictionary[IngredientType, String] = {
	IngredientType.NONE: "None",
	IngredientType.FAILED_RECIPE: "Sludge",
	IngredientType.BUTTER: "Butter",
	IngredientType.SUGAR: "Sugar",
	IngredientType.EGG: "Egg",
	IngredientType.FLOUR: "Flour",
	IngredientType.STRAWBERRY: "Strawberry",
	IngredientType.JAM: "Jam",
	IngredientType.BASIC_SPONGE: "Sponge",
	IngredientType.VICTORIA_SPONGE: "Victoria Sponge"
}
static var ingredient_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://cards/images/missing_tex.png"),
	IngredientType.FAILED_RECIPE: preload("res://cards/images/missing_tex.png"),
	IngredientType.BUTTER: preload("res://cards/images/missing_tex.png"),
	IngredientType.SUGAR: preload("res://cards/images/missing_tex.png"),
	IngredientType.EGG: preload("res://cards/images/egg.png"),
	IngredientType.FLOUR: preload("res://cards/images/missing_tex.png"),
	IngredientType.STRAWBERRY: preload("res://cards/images/missing_tex.png"),
	IngredientType.JAM: preload("res://cards/images/missing_tex.png"),
	IngredientType.BASIC_SPONGE: preload("res://cards/images/missing_tex.png"),
	IngredientType.VICTORIA_SPONGE: preload("res://cards/images/cake.png")
}
@export var ingredient_type: IngredientType = IngredientType.NONE:
	set(value):
		ingredient_type = value
		emit_changed()
var ingredient_quality: IngredientQuality = IngredientQuality.NONE
var ingredient_sell_price: int = 0
