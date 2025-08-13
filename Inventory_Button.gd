extends Button

var inventoryScreen = 0
var xAmount: int
var yAmount: int

func _ready():
	size = Vector2(180, 60)
	position = Vector2(2, 245)
	text = "Inventory"
	self.print_tree_pretty()
	get_window().size_changed.connect(_on_window_size_changed)
	pass 

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Open_Packs_Screen".deleteChildren();
	Player.inInventory = true;
	$"../VScrollBar".value = 0
	loadInventory();

func loadInventory() -> void:
	var xSize = get_viewport_rect().size.x - 285
	xAmount = int(xSize / 195)
	yAmount = int((get_viewport_rect().size.y)/ 300)
	print("Y amount: ", yAmount)
	if Player.cardInventory.size() > xAmount * yAmount:
		$"../VScrollBar".max_value = (ceil(((Player.cardInventory.size() - 1)/xAmount)) - (yAmount - 1))
		$"../VScrollBar".visible = true;
	else:
		$"../VScrollBar".visible = false;
		$"../VScrollBar".value = 0
	if Player.cardInventory.size() > 0:
		for x in Player.cardInventory.size():
			Player.cardInventory[x].showCard(getPosition(x).x, getPosition(x).y, 1)
			Player.cardInventory[x].displayUI()



func getPosition(x) -> Vector2:
	var row = x / xAmount
	var row_number = int(row)
	var base_y = row_number * 300
	var scroll_offset = $"../VScrollBar".value * 300
	var pos = Vector2(285 + ((x % xAmount) * 195), base_y - scroll_offset + 135)
	return pos

func _on_window_size_changed ():
	loadInventory()

func leaveInventory () -> void:
	$"../VScrollBar".visible = false;
	Player.inInventory = false
	for x in Player.cardInventory:
		x.visible = false;
