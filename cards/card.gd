extends Area2D

var is_dragging: bool = false
var mouse_position_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
