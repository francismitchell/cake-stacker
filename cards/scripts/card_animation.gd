extends Node

const SQUEEZE_TWEEN_TIME: float = 0.5
const SPAWN_IN_TWEEN_TIME: float = 0.25

@onready var card: Card = get_parent()
@onready var sprite: Sprite2D = get_parent().get_node("Sprite2D")


func basic_squeeze() -> void:
	var squeeze_tween: Tween = create_tween()
	squeeze_tween.tween_property(card, "scale:y", 1.0, SQUEEZE_TWEEN_TIME).from(0.85).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	squeeze_tween.parallel().tween_property(card, "scale:x", 1.0, SQUEEZE_TWEEN_TIME).from(0.85).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func play_spawn_animation(from_global_position: Vector2 = card.global_position) -> void:
	sprite.offset = from_global_position - card.global_position
	create_tween().tween_property(sprite, "offset", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	#create_tween().tween_property(card, "scale", Vector2(1.0, 1.0), SPAWN_IN_TWEEN_TIME).from(Vector2(0.5, 0.5)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func bounce_to_position(to_position: Vector2) -> void:
	var bounce_tween: Tween = create_tween()
