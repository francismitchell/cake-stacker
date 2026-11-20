extends Node

const RECIPES_DIR: String = "res://recipes/data/"

var recipes: Array[RecipeData]
var longest_recipe: int = 0
var recipe_length_to_recipes_dict: Dictionary[int, Array] = {}

static var ingredients_created = {}

signal ingredient_created(ingredient)

func _ready() -> void:
	var recipe_resources: PackedStringArray = ResourceLoader.list_directory(RECIPES_DIR)
	for recipe_res: String in recipe_resources:
		print("Loading recipe ", recipe_res)
		var recipe: RecipeData = load(RECIPES_DIR + recipe_res)
		var recipe_length: int = recipe.ingredients_in.values().reduce(func(accum, number): return accum + number, 0)
		if recipe_length_to_recipes_dict.has(recipe_length):
			recipe_length_to_recipes_dict[recipe_length].push_back(recipe)
		else:
			recipe_length_to_recipes_dict[recipe_length] = [recipe]
		if recipe_length > longest_recipe: longest_recipe = recipe_length 
		recipes.push_back(recipe)


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


func process_ingredients2(ingredients_in: Array[Card]) -> Array:
	# looking at the pile of ingredients above the baker card, we want to craft the recipe that uses
	# the most cards up in a sequence
	# get the next X cards above baker where X is equal to the recipe that uses the most cards
	# cards array comes in with card directly above baker at the front of the array, so slice from there
	var cards_to_check: Array[Card] = ingredients_in.slice(0, longest_recipe)
	for recipe_length: int in range(mini(longest_recipe, cards_to_check.size()), 0, -1):
		# now convert this to a dictionary
		var dict_to_check: Dictionary[IngredientData.IngredientType, int] = {}
		for card: Card in cards_to_check.slice(0, recipe_length):
			dict_to_check[card.card_data.ingredient_type] = dict_to_check.get(card.card_data.ingredient_type, 0) + 1
		# compare each recipe to the constructed dictionary
		for recipe: RecipeData in recipe_length_to_recipes_dict.get(recipe_length, []):
			if recipe.ingredients_in == dict_to_check:
				ingredient_created.emit(recipe.ingredient_out)
				return [recipe.ingredient_out, recipe_length]
	# return at least 1 so that it can turn the top card into a failed recipe card
	ingredient_created.emit(IngredientData.IngredientType.FAILED_RECIPE)
	return [IngredientData.IngredientType.FAILED_RECIPE, 1]
