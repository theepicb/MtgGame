extends VScrollBar

func _ready() -> void:
	var desired_height = (get_viewport_rect().size.y)
	custom_minimum_size = Vector2(custom_minimum_size.x, desired_height)
	visible = false
	
	anchor_left = 1
	anchor_right = 1
	offset_left = -60  # 20 pixels from right edge
	offset_right = -30
	connect("value_changed", Callable(self, "_on_VScrollBar_value_changed"))
	max_value = (get_viewport_rect().size.y / $"../../Upgrades".available_upgrades.size() * 70) + 20
	get_window().size_changed.connect(showBar)
	

func _on_VScrollBar_value_changed (value_changed):
	max_value = (20 + ($"../../Upgrades".available_upgrades.size() - 1)  * 70)
	var i = 0
	for child in $"../../Upgrades".buttons:
		child.position = Vector2(210, (20 + i * 70) - value_changed )
		i+= 1

func showBar():
	custom_minimum_size.y = get_viewport_rect().size.y
	max_value = (get_viewport_rect().size.y / $"../../Upgrades".available_upgrades.size() * 70) + 20
	if (get_viewport_rect().size.y <= 20 + ($"../../Upgrades".available_upgrades.size() * 70)) && $"../../Upgrades".inInv:
		visible = true
	else:
		visible = false
