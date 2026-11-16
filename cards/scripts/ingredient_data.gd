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
	BUTTERCREAM,
	GENOISE,
	SWISS_ROLL,
	COCOA_POWDER,
	CARROT,
	CREAM_CHEESE,
	CREAM_CHEESE_FROSTING,
	CARROT_SPONGE,
	CARROT_CAKE,
	DOUBLE_CARROT_SPONGE,
	CHOCOLATE_SPONGE,
	CHOCOLATE_BUTTERCREAM,
	CHOCOLATE_CAKE
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
	IngredientType.BASIC_SPONGE: "Basic Sponge",
	IngredientType.VICTORIA_SPONGE: "Victoria Sponge",
	IngredientType.CAKE: "Cake",
	IngredientType.BUTTERCREAM: "Buttercream",
	IngredientType.GENOISE: "Genoise Sponge",
	IngredientType.SWISS_ROLL: "Swiss Roll",
	IngredientType.COCOA_POWDER: "Cocoa Powder",
	IngredientType.CARROT: "Carrot",
	IngredientType.CREAM_CHEESE: "Cream Cheese",
	IngredientType.CREAM_CHEESE_FROSTING: "Cream Cheese Frosting",
	IngredientType.CARROT_SPONGE: "Carrot Sponge",
	IngredientType.CARROT_CAKE: "Carrot Cake",
	IngredientType.DOUBLE_CARROT_SPONGE: "Double Carrot Cake",
	IngredientType.CHOCOLATE_SPONGE: "Chocolate Sponge",
	IngredientType.CHOCOLATE_BUTTERCREAM: "Chocolate Buttercream",
	IngredientType.CHOCOLATE_CAKE: "Chocolate Cake"
}
const ingredient_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://cards/images/missing_tex.png"),
	IngredientType.FAILED_RECIPE: preload("res://cards/images/muck.jpg"),
	IngredientType.BUTTER: preload("res://cards/images/butter.jpg"),
	IngredientType.SUGAR: preload("res://cards/images/sugar.jpg"),
	IngredientType.EGG: preload("res://cards/images/egg.jpg"),
	IngredientType.FLOUR: preload("res://cards/images/missing_tex.png"),
	IngredientType.STRAWBERRY: preload("res://cards/images/missing_tex.png"),
	IngredientType.JAM: preload("res://cards/images/missing_tex.png"),
	IngredientType.BASIC_SPONGE: preload("res://cards/images/cooked sponge.jpg"),
	IngredientType.VICTORIA_SPONGE: preload("res://cards/images/missing_tex.png"),
	IngredientType.CAKE: preload("res://cards/images/cake.jpg"),
	IngredientType.BUTTERCREAM: preload("res://cards/images/missing_tex.png"),
	IngredientType.GENOISE: preload("res://cards/images/missing_tex.png"),
	IngredientType.SWISS_ROLL: preload("res://cards/images/missing_tex.png"),
	IngredientType.COCOA_POWDER: preload("res://cards/images/missing_tex.png"),
	IngredientType.CARROT: preload("res://cards/images/missing_tex.png"),
	IngredientType.CREAM_CHEESE: preload("res://cards/images/missing_tex.png"),
	IngredientType.CREAM_CHEESE_FROSTING: preload("res://cards/images/missing_tex.png"),
	IngredientType.CARROT_SPONGE: preload("res://cards/images/carrot_sponge.jpg"),
	IngredientType.CARROT_CAKE: preload("res://cards/images/carrot_cake.jpg"),
	IngredientType.DOUBLE_CARROT_SPONGE: preload("res://cards/images/double_carrot_sponge.jpg"),
	IngredientType.CHOCOLATE_SPONGE: preload("res://cards/images/missing_tex.png"),
	IngredientType.CHOCOLATE_BUTTERCREAM: preload("res://cards/images/missing_tex.png"),
	IngredientType.CHOCOLATE_CAKE: preload("res://cards/images/missing_tex.png")
}
const ingredient_source_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://cards/images/missing_tex.png"),
	IngredientType.BUTTER: preload("res://cards/images/missing_tex.png"),
	IngredientType.SUGAR: preload("res://cards/images/missing_tex.png"),
	IngredientType.EGG: preload("res://cards/images/egg_source.jpg"),
	IngredientType.FLOUR: preload("res://cards/images/missing_tex.png"),
	IngredientType.STRAWBERRY: preload("res://cards/images/missing_tex.png"),
	IngredientType.COCOA_POWDER: preload("res://cards/images/missing_tex.png"),
	IngredientType.CARROT: preload("res://cards/images/missing_tex.png"),
	IngredientType.CREAM_CHEESE: preload("res://cards/images/missing_tex.png")
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
