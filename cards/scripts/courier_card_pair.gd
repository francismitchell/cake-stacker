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
		Card.join(courier_card, destination_card)
		destination_card.reposition_cards()


func _on_courier_card_below_changed(card: Card) -> void:
	if card and card != destination_card and destination_card not in courier_card.get_child_cards():
		# only move if destination card is actually somewhere
		_move_to_destination.call_deferred()


func _move_to_destination() -> void:
	var stack_head: Card = courier_card.card_below
	var target: Card = destination_card.card_above
	if stack_head == null or target == null: return
	destination_card.detach()
	Card.join(target, stack_head)
	# then move the destination card to the bottom of the stack
	var stack_tail: Card = stack_head.get_bottom_card()
	Card.join(stack_tail, destination_card)
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
