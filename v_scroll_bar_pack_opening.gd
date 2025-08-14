extends VScrollBar

var yAmount: int
var xAmount: int
func _ready() -> void:
	var desired_height = (get_viewport_rect().size.y)
	custom_minimum_size = Vector2(custom_minimum_size.x, desired_height)
	visible = false
	
	anchor_left = 1
	anchor_right = 1
	offset_left = -60  # 20 pixels from right edge
	offset_right = -30
	connect("value_changed", Callable(self, "_on_VScrollBar_value_changed"))
	get_window().size_changed.connect(showBar)
	

func showBar():
	var xSize = get_viewport_rect().size.x - 285
	xAmount = int(xSize / 195)
	yAmount = int((get_viewport_rect().size.y)/ 300)
	max_value = (ceil(((Player.cardsToShow.size() - 1)/xAmount)) - (yAmount - 1))
	if Player.cardsToShow.size() > xAmount * yAmount:
		self.visible = true
	else:
		self.visible = false
	for x in Player.cardsToShow.size():
		Player.cardsToShow[x].showCard(getPosition(x).x, getPosition(x).y, 1)
		Player.cardsToShow[x].displayPrice()
	$"../Back_Button".position = Vector2((get_viewport_rect().size.x / 2) - 80, get_viewport_rect().size.y - 85);

func _on_VScrollBar_value_changed (value_changed):
	var cards_per_row = xAmount
	var card_height = 300  # height of one card row
	var scroll_offset = value * card_height
	print("Scrollbar moved to: ", value)
	
	for x in Player.cardsToShow.size():
		Player.cardsToShow[x].showCard(getPosition(x).x, getPosition(x).y, 1)
	

func getPosition(x) -> Vector2:
	var row = x / xAmount
	var row_number = int(row)
	var base_y = row_number * 300
	var scroll_offset = value * 300
	var pos = Vector2(285 + ((x % xAmount) * 195), base_y - scroll_offset + 135)
	return pos
