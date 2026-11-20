class_name CourierPair
extends Node2D

@onready var courier_card: Card = $CourierCard
@onready var destination_card: Card = $DestinationCard
@export var line_colour: Color = Color(0.284, 0.876, 0.98, 0.376)
@export var line_width: float = 6.0
var segment_fill: float = 0.7
var segment_length: float = 48.0
var line_start_offset: float
var end_circle_radius: float = 12.0

var _courier_card_position: Vector2 = Vector2.ZERO
var _destination_card_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination_card.card_released.connect(_on_destination_card_released)
	courier_card.card_below_changed.connect(_on_courier_card_below_changed)
	destination_card.z_index_changed.connect(func(): z_index = destination_card.get_bottom_card().z_index + 1)
	courier_card.z_index_changed.connect(func(): z_index = courier_card.get_bottom_card().z_index + 1)
	# link the two cards
	Card.join(courier_card, destination_card)


func _on_destination_card_released() -> void:
	if destination_card.card_above == null:
		Card.join(courier_card.get_bottom_card(), destination_card)


func _on_courier_card_below_changed(card: Card) -> void:
	if card and card != destination_card and destination_card not in courier_card.get_child_cards() \
		and card.card_data.card_type != CardData.CardType.DESTINATION:
		# only move if destination card is actually somewhere
		_move_to_destination.call_deferred()


func _move_to_destination() -> void:
	var stack_head: Card = courier_card.card_below
	if stack_head == null: return
	# we want to put it above our destination card and any other destination card in its stack
	var first_destination: Card = destination_card
	var target: Card = destination_card.card_above
	while target and target.card_data.card_type == CardData.CardType.DESTINATION:
		first_destination = target
		target = target.card_above
	if target == null: return
	if target == stack_head or target in stack_head.get_child_cards(): return
	# we also need the card below the ultimate target so we can reattach it
	var card_below_target: Card = first_destination
	# detach the target's card below, which may be this courier pair's destination card
	card_below_target.detach()
	# also check stack for other courier pair's destination cards that we want to keep here
	var destination_card_to_reattach: Card = null
	for child_card: Card in stack_head.get_child_cards():
		if child_card.card_data.card_type == CardData.CardType.DESTINATION:
			child_card.detach()
			destination_card_to_reattach = child_card
			break
	# remember stack tail to reattach target card to after joining the stack
	var stack_tail: Card = stack_head.get_bottom_card()
	Card.join(target, stack_head)
	if destination_card_to_reattach:
		Card.join(courier_card, destination_card_to_reattach)
	# then move this courier pair's destination card to the bottom of the stack
	Card.join(stack_tail, card_below_target)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line_start_offset = fmod(Engine.get_physics_frames(), segment_length)
	if courier_card == null or destination_card == null: return
	if courier_card.global_position + courier_card.animation.sprite.offset - global_position != _courier_card_position:
		_courier_card_position = courier_card.global_position + courier_card.animation.sprite.offset - global_position
	if destination_card.global_position + destination_card.animation.sprite.offset - global_position != _destination_card_position:
		_destination_card_position = destination_card.global_position + destination_card.animation.sprite.offset - global_position
	queue_redraw()

func _draw() -> void:
	# draw start and end circles
	draw_circle(_courier_card_position, end_circle_radius, line_colour)
	draw_circle(_destination_card_position, end_circle_radius, line_colour)
	var distance_along_line: float = 0
	var distance: float = _courier_card_position.distance_to(_destination_card_position)
	# line starts at edge of first circle and ends at edge of other circle
	var start_position: Vector2 = _courier_card_position.move_toward(_destination_card_position, end_circle_radius)
	var end_position: Vector2 = _destination_card_position.move_toward(_courier_card_position, end_circle_radius)
	while distance_along_line < distance:
		# draw the offset first segment
		if distance_along_line == 0:
			var gap_length: float = segment_length * (1.0 - segment_fill)
			# draw a line segment if the offset is larger than the gap length
			if line_start_offset - gap_length > 0:
				draw_line(start_position, start_position.move_toward(end_position, line_start_offset - gap_length), line_colour, line_width)
			distance_along_line = line_start_offset
		draw_line(start_position.move_toward(end_position, line_start_offset), start_position.move_toward(end_position, segment_length * segment_fill + line_start_offset), line_colour, line_width)
		# skip a whole segment length to create dash
		distance_along_line = move_toward(distance_along_line, distance, segment_length)
		# update next starting position
		start_position = start_position.move_toward(end_position, segment_length)
