extends Node2D

@onready var courier_card: Card = $CourierCard
@onready var destination_card: Card = $DestinationCard
@export var line_colour: Color = Color.WHITE
@export var line_width: float = 4.0

var _courier_card_position: Vector2 = Vector2.ZERO
var _destination_card_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination_card.card_released.connect(_on_destination_card_released)
	courier_card.card_below_changed.connect(_on_courier_card_below_changed)
	# link the two cards
	Card.join(courier_card, destination_card)


func _on_destination_card_released() -> void:
	if destination_card.card_above == null:
		Card.join(courier_card.get_bottom_card(), destination_card)
		destination_card.reposition_cards()


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
		destination_card_to_reattach.reposition_cards()
	# then move this courier pair's destination card to the bottom of the stack
	Card.join(stack_tail, card_below_target)
	stack_head.reposition_cards()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if courier_card.global_position != _courier_card_position:
		_courier_card_position = courier_card.global_position - global_position
		queue_redraw()
	if destination_card.global_position != _destination_card_position:
		_destination_card_position = destination_card.global_position - global_position
		queue_redraw()

func _draw() -> void:
	draw_line(_courier_card_position, _destination_card_position, line_colour, line_width)
