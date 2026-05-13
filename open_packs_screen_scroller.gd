extends VScrollBar

func _ready() -> void:
	visible = false  

	anchor_left = 1
	anchor_right = 1

	anchor_top = 0
	anchor_bottom = 1

	offset_left = 25
	offset_right = 10

	offset_top = 0
	offset_bottom = 0

	min_value = 0
	max_value = 10

	connect("value_changed", Callable(self, "_on_value_changed"))

func _on_value_changed(amount: float) -> void:
	var openScreen = $"../Pack_Screen"
	openScreen.set_scroll(amount)
