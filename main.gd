extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup proper object picking for cards
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
