extends Control

@onready var blocker_area_shape: CollisionShape2D = $ClickBlockerArea2D/CollisionShape2D
@onready var panel: PanelContainer = $MarginContainer/PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#%Egg.hide()
	#%Flour.hide()
	#%Sugar.hide()
	##%Butter.hide()
	#%Strawberry.hide()
	#%Cocoa.hide()
	#%Carrot.hide()
	#%CreamCheese.hide()
	#%CakeStand.hide()
	#%Baker.hide()
	#%CourierPair.hide()
	_fit_blocker()
	panel.resized.connect(_fit_blocker)
	SignalBus.shop_panel = $MarginContainer/PanelContainer
	visibility_changed.connect(func(): SignalBus.shop_open = visible)
	visibility_changed.connect(SignalBus.shop_visibility_changed.emit.bind(visible))
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.SWISS_ROLL)
	# unlock strawberry
	%Strawberry.locked = false
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CAKE)
	# unlock cocoa
	%Cocoa.locked = false
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CHOCOLATE_CAKE)
	# unlock carrot and cream cheese
	%Carrot.locked = false
	%CreamCheese.locked = false
	await SignalBus.await_ingredient_sold(IngredientData.IngredientType.CARROT_CAKE)
	# unlock automation
	%Egg.locked = false
	%Sugar.locked = false
	%Flour.locked = false
	%CakeStand.locked = false
	%Baker.locked = false
	%CourierPair.locked = false


func _fit_blocker() -> void:
	var rect: Rect2 = panel.get_global_rect()
	blocker_area_shape.shape.size = rect.size
	blocker_area_shape.global_position = rect.get_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()
