@tool
class_name Card
extends Area2D

const CARD_SCENE_PATH: String = "res://cards/scenes/card.tscn"
const SOURCE_CARD_SCENE_PATH: String = "res://cards/scenes/source_card.tscn"
const COURIER_PAIR_SCENE_PATH: String = "res://cards/scenes/courier_card_pair.tscn"
const PROCESS_TIME: float = 1.0
const SHOP_OPEN_TIME: float = 0.5
const SELL_TIME: float = 0.25
const MAX_AUTO_STACK_SIZE: int = 12
const STACK_SPACING: Vector2 = Vector2(0.0, 32.0)
const DRAGGING_Z_INDEX: int = 1000
const SHOP_CARD_Z_INDEX: int = 501
const SHOP_OPEN_Z_INDEX: int = 500

@export var card_data: CardData:
	set(value):
		if card_data and card_data.changed.is_connected(initialise_card_visuals):
			card_data.changed.disconnect(initialise_card_visuals)
		card_data = value
		if card_data:
			card_data.changed.connect(initialise_card_visuals)
		initialise_card_visuals()
@onready var card_label: Label = $SubViewport/PanelContainer/MarginContainer/Label
@onready var card_texture: TextureRect = $SubViewport/PanelContainer
@onready var card_quality_texture: TextureRect = $SubViewport/PanelContainer/StarTextureRect
@onready var animation = $Animation

var is_dragging: bool = false:
	set(value):
		if value == is_dragging: return
		is_dragging = value
		reassign_z_indices()
		if is_dragging and card_data.card_type == CardData.CardType.BAKER:
			if baker_progress_bar_tween:
				baker_progress_bar_tween.kill()
			$BakerProgressBar.hide()
var draggable: bool = true
@export var processable: bool = true
var mouse_position_offset: Vector2 = Vector2.ZERO
var cards_in_area: Array = []
# make these private variables with public getters to deter setting from outside script
var card_above: Card:
	get: return _card_above
var card_below: Card:
	get: return _card_below
var _card_above: Card = null
var _card_below: Card = null
var baker_progress_bar_tween: Tween = null
var cards_in_auto_stack_area: Array[Card] = []
var on_shop_layer: bool = false

signal card_processed
signal card_released
signal card_above_changed
signal card_below_changed


# ALWAYS use this to join cards
# use upper/lower nomenclature as we are working in join space
static func join(upper: Card, lower: Card) -> void:
	var old_upper: Card = lower._card_above
	if old_upper:
		old_upper._card_below = null
	lower._card_above = upper
	upper._card_below = lower
	if old_upper:
		old_upper.reassign_z_indices()
		old_upper.card_below_changed.emit(null)
	upper.reassign_z_indices()
	upper.get_top_card().layout_below()
	upper.card_below_changed.emit(lower)
	lower.card_above_changed.emit(upper)


# detaches this card from the one above
# NOTE does not detach from the card below
func detach() -> void:
	var old_upper: Card = _card_above
	if old_upper == null:
		return
	old_upper._card_below = null
	_card_above = null
	old_upper.reassign_z_indices()
	reassign_z_indices()
	old_upper.card_below_changed.emit(null)
	card_above_changed.emit(null)


static func create_baker_card() -> Card:
	var new_baker_card: Card = load(CARD_SCENE_PATH).instantiate()
	var baker_card_data: CardData = CardData.new()
	baker_card_data.card_type = CardData.CardType.BAKER
	new_baker_card.card_data = baker_card_data
	return new_baker_card


static func create_ingredient_card(ingredient_type: IngredientData.IngredientType) -> Card:
	var new_ingredient_card: Card = load(CARD_SCENE_PATH).instantiate()
	var ingredient_data: IngredientData = IngredientData.new()
	ingredient_data.ingredient_type = ingredient_type
	new_ingredient_card.card_data = ingredient_data
	return new_ingredient_card


static func create_source_card(ingredient_type: IngredientData.IngredientType) -> Card:
	var new_source_card: Card = load(SOURCE_CARD_SCENE_PATH).instantiate()
	var ingredient_data: IngredientData = IngredientData.new()
	ingredient_data.card_type = CardData.CardType.INGREDIENT_SOURCE
	ingredient_data.ingredient_type = ingredient_type
	new_source_card.card_data = ingredient_data
	return new_source_card


static func create_courier_pair() -> Node2D:
	var new_courier_pair: Node2D = load(COURIER_PAIR_SCENE_PATH).instantiate()
	return new_courier_pair


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reassign_z_indices()
	initialise_card_visuals()
	visibility_changed.connect(func(): processable = true if is_visible_in_tree() else false)
	visibility_changed.connect(func(): 
		if not is_visible_in_tree():
			detach()
			if card_below: card_below.detach())
	card_above_changed.connect(_on_card_above_changed)
	card_below_changed.connect(_on_card_below_changed)
	if not Engine.is_editor_hint():
		SignalBus.shop_visibility_changed.connect(_on_shop_visibility_changed)
	if card_data and card_data.card_type == CardData.CardType.BAKER:
		add_to_group("bakers")


func _exit_tree() -> void:
	# make sure to detach cards when selling/deleting cards so that we don't have broken references
	detach()


func _on_shop_visibility_changed(open: bool) -> void:
	if not open and on_shop_layer:
		on_shop_layer = false
		reassign_z_indices()


func _on_card_above_changed(_card: Card) -> void:
	if card_above:
		if card_data.card_type == CardData.CardType.BAKER:
			process_baker_logic()


func _on_card_below_changed(_card: Card) -> void:
	if card_below:
		# handle sell logic
		# selling should only get rid of the card at the top of the stack, not the whole stack
		if card_data.card_type == CardData.CardType.SELL:
			if SignalBus.shop_open: return
			if card_below.card_data.card_type == CardData.CardType.BAKER \
				and get_tree().get_nodes_in_group("bakers").size() <= 1: return
			var two_below: Card = card_below.card_below
			$BakerProgressBar.show()
			baker_progress_bar_tween = create_tween()
			baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, SELL_TIME).from(0.0)
			baker_progress_bar_tween.finished.connect(card_below.queue_free)
			baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)
			baker_progress_bar_tween.finished.connect(func():
				if card_below: card_below.detach()
				if two_below:
					Card.join(self, two_below))
			baker_progress_bar_tween.finished.connect(SignalBus.card_sold.emit.bind(card_below.card_data))


func initialise_card_visuals() -> void:
	if card_label == null or card_texture == null:
		return
	if card_data is IngredientData:
		card_data.card_name = IngredientData.ingredient_name_dict[card_data.ingredient_type]
		if IngredientData.ingredient_sell_price.has(card_data.ingredient_type):
			card_data.card_sell_price = IngredientData.ingredient_sell_price[card_data.ingredient_type]
		card_label.text = card_data.card_name
		if card_data.card_type == CardData.CardType.INGREDIENT:
			card_texture.texture = IngredientData.ingredient_texture_dict[card_data.ingredient_type]
			card_quality_texture.texture = IngredientData.ingredient_quality_texture_dict[card_data.ingredient_quality]
		elif card_data.card_type == CardData.CardType.INGREDIENT_SOURCE:
			card_texture.texture = IngredientData.ingredient_source_texture_dict[card_data.ingredient_type]
	if card_data.card_type == CardData.CardType.BAKER:
		card_label.text = "Baker"
		card_texture.texture = preload("res://cards/images/baker.jpg")
		card_quality_texture.texture = null
	elif card_data.card_type == CardData.CardType.SHOP:
		card_label.text = "Shop"
		draggable = false
	elif card_data.card_type == CardData.CardType.SELL:
		card_label.text = "Sell/bin"
		draggable = false
	elif card_data.card_type == CardData.CardType.BUY_INGREDIENT_SOURCE:
		draggable = false
	elif card_data.card_type == CardData.CardType.BUY_BAKER_CARD:
		card_texture.texture = preload("res://cards/images/baker.jpg")
		draggable = false
	elif card_data.card_type == CardData.CardType.BUY_COURIER_PAIR:
		card_texture.texture = preload("res://cards/images/missing_tex.png")
		draggable = false
	# important to ensure that viewport renders this frame
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# drag and move cards
	if is_dragging and draggable:
		global_position = get_global_mouse_position() - mouse_position_offset
		layout_below(false)


# handle drag starts here, i.e. when the card area is clicked
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not draggable: return
			animation.basic_squeeze()
			# set this before z index changed in is_dragging setter
			on_shop_layer = SignalBus.shop_open
			is_dragging = true
			# store mouse position offset so that cards drag from selected pixel
			mouse_position_offset = get_global_mouse_position() - global_position


# handle drops here
func _input(event: InputEvent) -> void:
	if not is_dragging: return
	if event is InputEventMouseButton:
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			_drop()


func _drop() -> void:
	is_dragging = false
	# check if shop should close
	if SignalBus.shop_open and not SignalBus.is_point_in_shop_panel(global_position): SignalBus.open_shop_card_processed.emit()
	# check if dropped on a card or stack
	if not cards_in_area.is_empty():
		# find first card with nothing below it
		for card: Card in cards_in_area:
			if card.card_below == null and card.is_visible_in_tree() and card not in get_child_cards() and not card.is_hidden_under_shop():
				Card.join(card, self)
				break
			# if dropped onto card that is already above it, reset position of this card and its children
			elif card.card_below == self:
				break
		# remove this card from above card if above card not one of the cards in dropped area
		if card_above:
			if card_above not in cards_in_area:
				detach()
		# if all cards in area are cards child cards, remove this card's card above
		var all_cards_in_area_are_children: bool = true
		for card: Card in cards_in_area:
			if card not in get_child_cards(): all_cards_in_area_are_children = false
		if all_cards_in_area_are_children: 
			detach()
	else:
		detach()
	get_top_card().layout_below()
	card_released.emit()


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


func layout_below(animate: bool = true) -> void:
	var slot: Vector2 = global_position
	var card: Card = card_below
	# dragged cards will follow the mouse
	while card and not card.is_dragging:
		slot += STACK_SPACING
		card.place_at(slot, animate)
		card = card.card_below


func place_at(new_global_position: Vector2, animate: bool) -> void:
	# animation node won't be ready at load
	if not animate or not is_node_ready():
		global_position = new_global_position
		return
	animation.slide_to(new_global_position)


func _is_shop_layer() -> bool:
	return on_shop_layer or card_data.card_type == CardData.CardType.BUY_INGREDIENT_SOURCE \
		or card_data.card_type == CardData.CardType.BUY_BAKER_CARD \
		or card_data.card_type == CardData.CardType.BUY_COURIER_PAIR


func is_hidden_under_shop() -> bool:
	return not get_top_card()._is_shop_layer() and SignalBus.is_point_in_shop_panel(global_position)


func reassign_z_indices() -> void:
	var card: Card = get_top_card()
	var z_index_base: int = SHOP_CARD_Z_INDEX if card._is_shop_layer() else 0
	var i: int = 0
	var lifted: bool = false
	while card:
		lifted = lifted or card.is_dragging
		card.z_index = z_index_base + i + (DRAGGING_Z_INDEX if lifted else 0)
		card = card.card_below
		i += 1


func get_top_card() -> Card:
	var top_card: Card = self
	while top_card.card_above:
		top_card = top_card.card_above
	return top_card


func get_bottom_card() -> Card:
	var bottom_card: Card = self
	while bottom_card.card_below:
		bottom_card = bottom_card.card_below
	return bottom_card


func process_baker_logic() -> void:
	if not card_above.processable: return
	if card_above.card_data.card_type == CardData.CardType.INGREDIENT:
		# start cooking
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, PROCESS_TIME).from(0.0)
		baker_progress_bar_tween.finished.connect(baker_process_ingredients)
		baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)
	elif card_above.card_data.card_type == CardData.CardType.INGREDIENT_SOURCE:
		# start producing new ingredient
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.set_loops()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, PROCESS_TIME).from(0.0)
		baker_progress_bar_tween.loop_finished.connect(baker_create_ingredient)
		baker_progress_bar_tween.loop_finished.connect(card_above.card_processed.emit)
	elif card_above.card_data.card_type == CardData.CardType.SHOP:
		# start producing new ingredient
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, SHOP_OPEN_TIME).from(0.0)
		baker_progress_bar_tween.finished.connect(SignalBus.open_shop_card_processed.emit)
		baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)
	elif card_above.card_data.card_type == CardData.CardType.BUY_INGREDIENT_SOURCE:
		# start buying card
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, SHOP_OPEN_TIME).from(0.0)
		baker_progress_bar_tween.finished.connect(SignalBus.source_card_purchased.emit.bind(card_above.card_data.ingredient_type, global_position))
		baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)
	elif card_above.card_data.card_type == CardData.CardType.BUY_BAKER_CARD:
		# start buying card
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, SHOP_OPEN_TIME).from(0.0)
		baker_progress_bar_tween.finished.connect(SignalBus.baker_card_purchased.emit.bind(global_position))
		baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)
	elif card_above.card_data.card_type == CardData.CardType.BUY_COURIER_PAIR:
		# start buying card
		$BakerProgressBar.show()
		baker_progress_bar_tween = create_tween()
		baker_progress_bar_tween.tween_property($BakerProgressBar, "value", 100.0, SHOP_OPEN_TIME).from(0.0)
		baker_progress_bar_tween.finished.connect(SignalBus.courier_pair_purchased.emit.bind(global_position))
		baker_progress_bar_tween.finished.connect($BakerProgressBar.hide)


func baker_process_ingredients() -> void:
	var ingredients_in: Dictionary[IngredientData.IngredientType, int] = {}
	var card_above_this = card_above
	var cards_above: Array[Card]
	while card_above_this:
		if card_above_this.card_data.card_type == CardData.CardType.INGREDIENT:
			cards_above.push_back(card_above_this)
			if ingredients_in.has(card_above_this.card_data.ingredient_type):
				ingredients_in[card_above_this.card_data.ingredient_type] += 1
			else:
				ingredients_in[card_above_this.card_data.ingredient_type] = 1
		card_above_this = card_above_this.card_above
	var new_card: Card = create_ingredient_card(RecipeManager.process_ingredients(ingredients_in))
	new_card.global_position = global_position
	var target_position = global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	# hard coded image half sizes
	target_position.x = clampf(target_position.x, 64.0, get_viewport().get_visible_rect().size.x - 64.0)
	target_position.y = clampf(target_position.y, 96.0, get_viewport().get_visible_rect().size.y - 96.0)
	create_tween().tween_property(new_card, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	get_parent().add_child(new_card)
	new_card.animation.play_spawn_animation()
	for card: Card in cards_above:
		card.queue_free()


func baker_create_ingredient(_loop_count: int) -> void:
	# edge case: return if card above no longer valid for some reason
	if not card_above: 
		baker_progress_bar_tween.kill()
		$BakerProgressBar.hide()
		return
	var new_card: Card = create_ingredient_card(card_above.card_data.ingredient_type)
	var target_position = global_position + Vector2(0.0, 196.0).rotated(randf() * TAU)
	# hard coded image half sizes
	target_position.x = clampf(target_position.x, 64.0, get_viewport().get_visible_rect().size.x - 64.0)
	target_position.y = clampf(target_position.y, 96.0, get_viewport().get_visible_rect().size.y - 96.0)
	# find where to autostack
	var auto_stack_card: Card = null
	# first pass, check if we have a courier card below the baker card
	if card_below:
		if card_below.card_data.card_type == CardData.CardType.COURIER:
			auto_stack_card = card_below
	# IMPORTANT: only ingredient source cards have an auto stack area, so we must query it
	if not auto_stack_card: auto_stack_card = card_above.get_auto_stack_card(new_card)
	if auto_stack_card:
		var child_cards: Array[Card] = auto_stack_card.get_child_cards()
		if child_cards:
			if child_cards.size() + 1 >= MAX_AUTO_STACK_SIZE:
				baker_progress_bar_tween.kill()
				$BakerProgressBar.hide()
				return
			Card.join(child_cards.back(), new_card)
		else:
			Card.join(auto_stack_card, new_card)
	else:
		new_card.global_position = target_position
	get_parent().add_child(new_card)
	new_card.animation.play_spawn_animation(global_position)


func get_auto_stack_card(card: Card) -> Card:
	for auto_stack_card: Card in cards_in_auto_stack_area:
		if auto_stack_card.is_hidden_under_shop(): continue
		var is_auto_stackable: bool = true
		# reject cards not at the bottom of the stack
		if auto_stack_card.card_above != null: continue
		# reject bottom of stack cards being dragged
		if auto_stack_card.is_dragging: continue
		# reject bottom of stack cards of different ingredient types
		if auto_stack_card.card_data.ingredient_type != card.card_data.ingredient_type: continue
		var child_cards: Array[Card] = auto_stack_card.get_child_cards()
		for child_card: Card in child_cards:
			if child_card.card_data.card_type != CardData.CardType.INGREDIENT or child_card.card_data.ingredient_type != auto_stack_card.card_data.ingredient_type:
				# reject bottom of stack cards where a child has a different ingredient type
				is_auto_stackable = false
				break
		if is_auto_stackable:
			return auto_stack_card
	return null


func _on_auto_stack_area_2d_area_entered(area: Area2D) -> void:
	if area is not Card: return
	# only add ingredient cards
	if area.card_data.card_type == CardData.CardType.INGREDIENT:
		cards_in_auto_stack_area.push_back(area)


func _on_auto_stack_area_2d_area_exited(area: Area2D) -> void:
	if area is not Card: return
	if cards_in_auto_stack_area.has(area):
		cards_in_auto_stack_area.erase(area)
