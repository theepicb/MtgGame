extends ScrollContainer

func _ready():

	size = get_viewport_rect().size

	position = Vector2(200, 0)
	size = Vector2(
		size.x - 200,
		size.y
	)
