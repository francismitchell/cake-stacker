@tool
class_name Card
extends Area2D

const CARD_SCENE = preload("res://cards/card.tscn")

@export var card_data: CardData:
	set(value):
		if card_data and card_data.changed.is_connected(initialise_card_visuals):
			card_data.changed.disconnect(initialise_card_visuals)
		card_data = value
		if card_data:
			card_data.changed.connect(initialise_card_visuals)
		initialise_card_visuals()
@onready var card_label: Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/Label
@onready var card_texture: TextureRect = $SubViewport/PanelContainer

var is_dragging: bool = false
var mouse_position_offset: Vector2 = Vector2.ZERO
var cards_in_area: Array = []
var card_above: Card = null:
	set(value):
		var last_card_above = card_above
		card_above = value
		if card_above:
			if last_card_above and card_above != last_card_above:
				last_card_above.card_below = null
		if card_above and card_data.card_type == CardData.CardType.BAKER:
			# start cooking
			var ingredients_in: Dictionary[IngredientData.IngredientType, int] = {}
			var card_above_this = card_above
			var cards_above: Array[Card]
			while card_above_this:
				cards_above.push_back(card_above_this)
				if ingredients_in.has(card_above_this.card_data.ingredient_type):
					ingredients_in[card_above_this.card_data.ingredient_type] += 1
				else:
					ingredients_in[card_above_this.card_data.ingredient_type] = 1
				card_above_this = card_above_this.card_above
			var new_ingredient_data = IngredientData.new()
			new_ingredient_data.ingredient_type = RecipeManager.process_ingredients(ingredients_in)
			var new_card: Card = CARD_SCENE.instantiate()
			new_card.card_data = new_ingredient_data
			new_card.global_position = card_above.global_position
			create_tween().tween_property(new_card, "global_position", new_card.global_position + Vector2(randf_range(-128.0, 128.0),randf_range(-128.0, 128.0)), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			get_parent().add_child(new_card)
			for card: Card in cards_above:
				card.queue_free()
				
var card_below: Card = null:
	set(value):
		var last_card_below = card_below
		card_below = value
		if card_below:
			if last_card_below and card_below != last_card_below:
				last_card_below.card_below = null
var child_cards_to_move: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialise_card_visuals()


func initialise_card_visuals() -> void:
	if card_label == null or card_texture == null:
		return
	if card_data is IngredientData:
		card_data.card_name = IngredientData.ingredient_name_dict[card_data.ingredient_type]
		card_label.text = card_data.card_name
		card_texture.texture = IngredientData.ingredient_texture_dict[card_data.ingredient_type]
	if card_data.card_type == CardData.CardType.BAKER:
		card_label.text = "Baker"
		card_texture.texture = preload("res://icon.svg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# drag and move cards
	if is_dragging:
		var target_position = get_global_mouse_position() - mouse_position_offset
		for child_card: Card in child_cards_to_move:
			var offset = child_card.global_position - global_position
			child_card.global_position = target_position + offset
		global_position = target_position


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = true
			# ensure dragged card is always at the top of the canvas
			z_index = 99
			# store mouse position offset so that cards drag from selected pixel
			mouse_position_offset = get_global_mouse_position() - global_position
			# get child cards to move with this one
			child_cards_to_move = get_child_cards()
			# ensure child cards are z sorted above this one
			var i: int = z_index + 1
			for child_card: Card in child_cards_to_move:
				child_card.z_index = i
				i += 1
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			# check if dropped on a card or stack
			if not cards_in_area.is_empty():
				# find first card with nothing below it
				for card: Card in cards_in_area:
					if card.card_below == null and card not in get_child_cards():
						card.card_below = self
						card_above = card
						z_index = card_above.z_index + 1
						reposition_cards()
						break
					# if dropped onto card that is already above it, reset position of this card and its children
					elif card.card_below == self:
						reposition_cards()
						break
				# remove this card from above card if above card not one of the cards in dropped area
				if card_above:
					if card_above not in cards_in_area:
						card_above.card_below = null
				# if all cards in area are cards child cards, remove this card's card above
				var all_cards_in_area_are_children: bool = true
				for card: Card in cards_in_area:
					if card not in get_child_cards(): all_cards_in_area_are_children = false
				if all_cards_in_area_are_children: 
					card_above = null
					z_index = 0
			else:
				if card_above:
					card_above.card_below = null
					card_above = null
				if card_below:
					card_below.card_above = null
					card_below = null
			# z sorting
			if card_above:
				z_index = card_above.z_index + 1
			else:
				z_index = 0
			var i = z_index + 1
			var card_below_this: Card = card_below
			while card_below_this:
				card_below_this.z_index = i
				card_below_this = card_below_this.card_below
				i += 1

func reposition_cards() -> void:
	var target_position = card_above.global_position + Vector2(0.0, 32.0)
	create_tween().tween_property(self, "global_position", target_position, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var i = 1
	for child_card: Card in get_child_cards():
		create_tween().tween_property(child_card, "global_position", target_position + i * Vector2(0.0, 32.0), 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		i += 1


func _on_area_entered(area: Area2D) -> void:
	cards_in_area.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	if cards_in_area.has(area):
		cards_in_area.erase(area)

func get_child_cards() -> Array[Card]:
	var child_cards: Array[Card] = []
	var card_below_this: Card = card_below
	# ensure child cards are below this one
	while card_below_this:
		child_cards.push_back(card_below_this) 
		card_below_this = card_below_this.card_below
	return child_cards
