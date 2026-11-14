@tool
class_name IngredientCard
extends Area2D

@export var card_data: CardData:
	set(value):
		if card_data and card_data.changed.is_connected(initialise_card_visuals):
			card_data.changed.disconnect(initialise_card_visuals)
		card_data = value
		if card_data:
			card_data.changed.connect(initialise_card_visuals)
		initialise_card_visuals()

@onready var card_label: Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/Label
@onready var card_texture: TextureRect = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/TextureRect

var is_dragging: bool = false
var mouse_position_offset: Vector2 = Vector2.ZERO
var cards_in_area: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialise_card_visuals()


func initialise_card_visuals() -> void:
	if card_label == null or card_texture == null:
		return
	if card_data is IngredientData:
		card_label.text = IngredientData.ingredient_name_dict[card_data.ingredient_type]
		card_texture.texture = IngredientData.ingredient_texture_dict[card_data.ingredient_type]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# drag and move cards
	if is_dragging:
		global_position = get_global_mouse_position() - mouse_position_offset


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = true
			# ensure dragged card is always at the top of the canvas
			z_index = 99
			# store mouse position offset so that cards drag from selected pixel
			mouse_position_offset = get_global_mouse_position() - global_position
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			z_index = 0
			# check if dropped on a card or stack
			if not cards_in_area.is_empty():
				# card DROPPED onto another card, therefore this card should be in front of it
				z_index = cards_in_area.front().z_index + 1
				# for now, align with position offset slightly
				var target_position: Vector2 = cards_in_area.front().global_position + Vector2(0.0, 32.0)
				create_tween().tween_property(self, "global_position", target_position, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_area_entered(area: Area2D) -> void:
	cards_in_area.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	if cards_in_area.has(area):
		cards_in_area.erase(area)
