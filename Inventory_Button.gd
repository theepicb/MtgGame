extends Button

var inventoryScreen = 0
var xAmount: int
var yAmount: int
var currentInv = 0
var chosenScreen = Player.cardInventory

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
	$"../inventory".visible = true
	$"../binder".visible = true
	loadInventory();

func choseScreenReload():
	if currentInv == 0:
		chosenScreen = Player.cardInventory
		
	elif currentInv == 1:
		chosenScreen = Player.binder
	chosenScreen.sort_custom(func(a, b): return a.price > b.price)

func loadInventory() -> void:
	if currentInv == 0:
		chosenScreen = Player.cardInventory
	elif currentInv == 1:
		chosenScreen = Player.binder
	chosenScreen.sort_custom(func(a, b): return a.price > b.price)
	$"../Sell_All".visible = true
	var xSize = get_viewport_rect().size.x - 285
	xAmount = int(xSize / 195)
	yAmount = int((get_viewport_rect().size.y - 100)/ 300)
	print("Y amount: ", yAmount)
	if chosenScreen.size() > xAmount * yAmount:
		$"../VScrollBar".max_value = (ceil(((chosenScreen.size() - 1)/$"../Inventory_Button".xAmount)) - ($"../Inventory_Button".yAmount - 1 ) - 0.7)
		$"../VScrollBar".visible = true;
	else:
		$"../VScrollBar".visible = false;
		$"../VScrollBar".value = 0
	if chosenScreen.size() > 0:
		for x in chosenScreen.size():
			if is_instance_valid(chosenScreen[x]):
				chosenScreen[x].showCard(getPosition(x).x, getPosition(x).y, 1, 100)
				chosenScreen[x].displayUI()
	var desired_height = (get_viewport_rect().size.y)
	$"../VScrollBar".custom_minimum_size = Vector2(custom_minimum_size.x, desired_height)


func getPosition(x) -> Vector2:
	var row = x / xAmount
	var row_number = int(row)
	var base_y = row_number * 300
	var scroll_offset = $"../VScrollBar".value * 300
	var pos = Vector2(285 + ((x % xAmount) * 195), base_y - scroll_offset + 135)
	return pos

func _on_window_size_changed ():
	$ResizeDebounceTimer.start()

	
func _on_resize_debounce_timer_timeout() -> void:
	if Player.inInventory:
		loadInventory()

func leaveInventory () -> void:
	$"../Sell_All".visible = false
	$"../VScrollBar".visible = false;
	$"../inventory".visible = false
	$"../binder".visible = false
	Player.inInventory = false
	for x in Player.cardInventory:
		x.visible = false;
	for x in Player.binder:
		x.visible = false



	
