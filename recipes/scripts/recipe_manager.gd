extends Node

const RECIPES_DIR: String = "res://recipes/data/"

var recipes: Array[RecipeData]

func _ready() -> void:
	var recipe_resources: PackedStringArray = ResourceLoader.list_directory(RECIPES_DIR)
	for recipe_res: String in recipe_resources:
		print("Loading recipe ", recipe_res)
		recipes.push_back(load(RECIPES_DIR + recipe_res))


func process_ingredients(ingredients_in: Dictionary[IngredientData.IngredientType, int]) -> IngredientData.IngredientType:
	for recipe: RecipeData in recipes:
		# godot lets you compare dictionary keys and values at the same time regardless of order
		if recipe.ingredients_in == ingredients_in:
			return recipe.ingredient_out
	# if no recipe found, return failed recipe card
	return IngredientData.IngredientType.FAILED_RECIPE
