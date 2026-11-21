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
	CHOCOLATE_CAKE,
	VANILLA_CAKE,
	DOUBLE_CHOCOLATE_SPONGE
	}
enum IngredientQuality {NONE, SILVER, GOLD, PLATINUM}

const final_ingredients = [
	IngredientType.SWISS_ROLL,
	IngredientType.VANILLA_CAKE,
	IngredientType.VICTORIA_SPONGE, 
	IngredientType.CAKE, 
	IngredientType.CHOCOLATE_CAKE,
	IngredientType.CARROT_CAKE
]

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
	IngredientType.BUTTERCREAM: "Buttercream",
	IngredientType.GENOISE: "Sheet Cake",
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
	IngredientType.CHOCOLATE_CAKE: "Chocolate Cake",
	IngredientType.VANILLA_CAKE: "Vanilla Cake",
	IngredientType.DOUBLE_CHOCOLATE_SPONGE: "Double Chocolate Sponge"
}
const ingredient_texture_dict: Dictionary[IngredientType, Texture2D] = {
	IngredientType.NONE: preload("res://cards/images/missing_tex.png"),
	IngredientType.FAILED_RECIPE: preload("res://cards/images/muck.jpg"),
	IngredientType.BUTTER: preload("res://cards/images/butter.jpg"),
	IngredientType.SUGAR: preload("res://cards/images/sugar.jpg"),
	IngredientType.EGG: preload("res://cards/images/egg.jpg"),
	IngredientType.FLOUR: preload("res://cards/images/flour.jpg"),
	IngredientType.STRAWBERRY: preload("res://cards/images/strawberry.jpg"),
	IngredientType.JAM: preload("res://cards/images/jam.jpg"),
	IngredientType.BASIC_SPONGE: preload("res://cards/images/cooked sponge.jpg"),
	IngredientType.VICTORIA_SPONGE: preload("res://cards/images/missing_tex.png"), ###########
	IngredientType.BUTTERCREAM: preload("res://cards/images/buttercream.jpg"),
	IngredientType.GENOISE: preload("res://cards/images/sheet_cake.jpg"),
	IngredientType.SWISS_ROLL: preload("res://cards/images/swiss_roll.jpg"),
	IngredientType.COCOA_POWDER: preload("res://cards/images/cocoa.jpg"),
	IngredientType.CARROT: preload("res://cards/images/carrot.jpg"),
	IngredientType.CREAM_CHEESE: preload("res://cards/images/cream_cheese_icing.jpg"),
	IngredientType.CREAM_CHEESE_FROSTING: preload("res://cards/images/cream_cheese_icing.jpg"),
	IngredientType.CARROT_SPONGE: preload("res://cards/images/carrot_sponge.jpg"),
	IngredientType.CARROT_CAKE: preload("res://cards/images/carrot_cake.jpg"),
	IngredientType.DOUBLE_CARROT_SPONGE: preload("res://cards/images/double_carrot_sponge.jpg"),
	IngredientType.CHOCOLATE_SPONGE: preload("res://cards/images/chocolate_sponge.jpg"),
	IngredientType.CHOCOLATE_BUTTERCREAM: preload("res://cards/images/chocolate_buttercream.jpg"),
	IngredientType.CHOCOLATE_CAKE: preload("res://cards/images/chocolate_cake.jpg"),
	IngredientType.VANILLA_CAKE: preload("res://cards/images/cake.jpg"),
	IngredientType.DOUBLE_CHOCOLATE_SPONGE: preload("res://cards/images/double_chocolate_sponge.jpg")
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
const ingredient_sell_price: Dictionary[IngredientType, int] = {
	IngredientType.JAM: 1,
	IngredientType.BASIC_SPONGE: 2,
	IngredientType.BUTTERCREAM: 1,
	IngredientType.GENOISE: 2,
	IngredientType.CREAM_CHEESE_FROSTING: 2,
	IngredientType.CARROT_SPONGE: 3,
	IngredientType.DOUBLE_CARROT_SPONGE: 6,
	IngredientType.DOUBLE_CHOCOLATE_SPONGE: 6,
	IngredientType.CHOCOLATE_SPONGE: 3,
	IngredientType.CHOCOLATE_BUTTERCREAM: 3,
	IngredientType.SWISS_ROLL: 10,
	IngredientType.VICTORIA_SPONGE: 12,
	IngredientType.VANILLA_CAKE: 12,
	IngredientType.CAKE: 15,
	IngredientType.CHOCOLATE_CAKE: 20,
	IngredientType.CARROT_CAKE: 25
}
@export var ingredient_type: IngredientType = IngredientType.NONE:
	set(value):
		ingredient_type = value
		emit_changed()
var ingredient_quality: IngredientQuality = IngredientQuality.NONE
