extends TextureButton

@export var ingredient_type: IngredientData.IngredientType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	SignalBus.source_card_purchased.emit(ingredient_type)
