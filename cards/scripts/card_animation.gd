extends Node

const SQUEEZE_TWEEN_TIME: float = 0.5

@onready var card: Card = get_parent()


func basic_squeeze() -> void:
	var squeeze_tween: Tween = create_tween()
	squeeze_tween.tween_property(card, "scale:y", 1.0, SQUEEZE_TWEEN_TIME).from(0.85).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	squeeze_tween.parallel().tween_property(card, "scale:x", 1.0, SQUEEZE_TWEEN_TIME).from(0.85).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func bounce_to_position(to_position: Vector2) -> void:
	var bounce_tween: Tween = create_tween()
