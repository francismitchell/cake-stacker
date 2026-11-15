@tool
extends TextureButton

@onready var label: Label = $Label
@export var ingredient_type: IngredientData.IngredientType:
	set(value):
		ingredient_type = value
		_update_label()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_label()

func _update_label() -> void:
	if label:
		label.text = IngredientData.ingredient_name_dict[ingredient_type]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	SignalBus.source_card_purchased.emit(ingredient_type)
