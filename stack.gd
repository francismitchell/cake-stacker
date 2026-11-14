class_name CardStack
extends RefCounted

const CARD_OFFSET: Vector2 = Vector2(0.0, 32.0)

var cards: Array[Card]

static var num_stacks: int = 0

func _init() -> void:
	num_stacks += 1

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		num_stacks -= 1
		print('num stacks: ', get_number_stacks())

static func get_number_stacks() -> int:
	return num_stacks

func join_stack(card: Card) -> void:
	if not cards.has(card):
		cards.push_back(card)
	print('num stacks: ', get_number_stacks())

func leave_stack(card: Card) -> void:
	if cards.has(card):
		cards.erase(card)
	if cards.size() == 1:
		cards[0].card_stack = null

func get_next_z_index() -> int:
	return cards.back().z_index + 1

func get_next_global_position() -> Vector2:
	return cards.front().global_position + (cards.size() - 1) * CARD_OFFSET
