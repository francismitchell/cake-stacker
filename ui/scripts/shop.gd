extends Control

@onready var blocker_area_shape: CollisionShape2D = $ClickBlockerArea2D/CollisionShape2D
@onready var panel: PanelContainer = $MarginContainer/PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fit_blocker()
	panel.resized.connect(_fit_blocker)
	SignalBus.shop_panel = $MarginContainer/PanelContainer
	visibility_changed.connect(func(): SignalBus.shop_open = visible)
	visibility_changed.connect(SignalBus.shop_visibility_changed.emit.bind(visible))
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.SWISS_ROLL)
	# unlock strawberry
	#$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Butter/Card.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CAKE)
	# unlock cocoa
	#$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Cocoa/Card.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CHOCOLATE_CAKE)
	# unlock carrot and cream cheese
	#$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Carrot/Card.processable = true
	#$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Butter/CreamCheese.processable = true
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CARROT_CAKE)
	# unlock ???


func _fit_blocker() -> void:
	var rect: Rect2 = panel.get_global_rect()
	blocker_area_shape.shape.size = rect.size
	blocker_area_shape.global_position = rect.get_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()
