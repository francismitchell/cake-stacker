extends Node

const RECIPES_DIR: String = "res://recipes/data/"

var recipes: Array[RecipeData]

static var ingredients_created = {}

signal ingredient_created(ingredient)

func _ready() -> void:
	var recipe_resources: PackedStringArray = ResourceLoader.list_directory(RECIPES_DIR)
	for recipe_res: String in recipe_resources:
		print("Loading recipe ", recipe_res)
		recipes.push_back(load(RECIPES_DIR + recipe_res))


func process_ingredients(ingredients_in: Dictionary[IngredientData.IngredientType, int]) -> IngredientData.IngredientType:
	var ingredient_out: IngredientData.IngredientType = IngredientData.IngredientType.FAILED_RECIPE
	for recipe: RecipeData in recipes:
		# godot lets you compare dictionary keys and values at the same time regardless of order
		if recipe.ingredients_in == ingredients_in:
			ingredient_out = recipe.ingredient_out
			break
	ingredient_created.emit(ingredient_out)
	if ingredients_created.has(ingredient_out):
		ingredients_created[ingredient_out] += 1
	else:
		ingredients_created[ingredient_out] = 1
	return ingredient_out
