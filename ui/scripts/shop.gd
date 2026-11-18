extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.SWISS_ROLL)
	# unlock strawberry
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Butter/Card.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CAKE)
	# unlock cocoa
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Cocoa/Card.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CHOCOLATE_CAKE)
	# unlock carrot and cream cheese
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Carrot/Card.processable = true
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Butter/CreamCheese.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CARROT_CAKE)
	# unlock ???


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()
