extends VScrollBar

var count = 0;

func _ready() -> void:
	visible = false;

	# Set vertical anchors to center (top and bottom at 0.5)
	anchor_top = 0.5
	anchor_bottom = 0.5

	# Set fixed height for the scrollbar
	var desired_height = 900
	custom_minimum_size = Vector2(custom_minimum_size.x, desired_height)

	# Offsets position scrollbar so it's centered vertically
	offset_top = -desired_height / 2
	offset_bottom = desired_height / 2

	# Position scrollbar near the right edge
	anchor_left = 1
	anchor_right = 1
	offset_left = -60  # 20 pixels from right edge
	offset_right = -30
	
	connect("value_changed", Callable(self, "_on_VScrollBar_value_changed"))

# Called when the scrollbar value changes
func _on_VScrollBar_value_changed(value):
	var cards_per_row = 8
	var card_height = 300  # height of one card row
	var scroll_offset = value * card_height
	print("Scrollbar moved to: ", value)
	
	max_value = (ceil(((Player.cardInventory.size() - 1)/8)) - 2)
	count = value
	for i in range(Player.cardInventory.size()):
		var card = Player.cardInventory[i]
		var row = i / cards_per_row  # use integer division or floor
		var row_number = int(row)    # convert to int (floor)
		var base_y = row_number * card_height
		card.position.y = base_y - scroll_offset + 135
	if Player.cardInventory.size() <= 24:
		self.visible = false
