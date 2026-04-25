extends Button

var inventoryScreen = 0
var xAmount: int
var yAmount: int

var chosenScreen = Player.cardInventory
var sorted_keys: Array = []

var scroll_offset := 0.0  # <-- single source of truth

func _ready():
	size = Vector2(180, 60)
	position = Vector2(2, 245)
	text = "Inventory"

	get_window().size_changed.connect(_on_window_size_changed)

func _pressed() -> void:
	$"../../Money_Clicker".visible = false
	$"../../Pack_Clicker".visible = false
	$"../../Upgrades".deleteChildren()
	$"../../Pack_Screen".deleteChildren()
	$"../Open_Packs_Screen".deleteChildren()

	Player.inInventory = true
	$"../VScrollBar".value = 0
	$"../VScrollBar".visible = true

	$"../inventory".visible = true
	$"../binder".visible = true

	loadInventory()


func loadInventory() -> void:
	if inventoryScreen == 0:
		chosenScreen = Player.cardInventory
		$"../Sell_All".visible = true
	elif inventoryScreen == 1:
		chosenScreen = Player.binder

	sorted_keys = chosenScreen.keys()
	sorted_keys.sort_custom(func(a, b): return chosenScreen[a].price > chosenScreen[b].price)

	var xSize = get_viewport_rect().size.x - 285
	xAmount = int(xSize / 195)
	yAmount = int((get_viewport_rect().size.y - 100) / 300)

	# scrollbar setup
	var sb = $"../VScrollBar"
	if chosenScreen.size() > xAmount * yAmount:
		sb.max_value = max(0, ceil((chosenScreen.size() - xAmount * yAmount) / float(xAmount)))
		sb.visible = true
	else:
		sb.visible = false
		sb.value = 0
		scroll_offset = 0

	refresh_positions()


func set_scroll(value: float) -> void:
	scroll_offset = value
	refresh_positions()


func refresh_positions() -> void:
	var i := 0

	for key in sorted_keys:
		var card = chosenScreen[key]
		if !is_instance_valid(card):
			continue

		var row = i / xAmount
		var col = i % xAmount

		var x = 285 + (col * 195)
		var y = 135 + (row * 300) - (scroll_offset * 300)

		card.showCard(x, y, 1, 100)
		card.displayUI()

		i += 1


func _on_window_size_changed():
	$ResizeDebounceTimer.start()

func _on_resize_debounce_timer_timeout():
	if Player.inInventory:
		loadInventory()


func leaveInventory():
	$"../Sell_All".visible = false
	$"../VScrollBar".visible = false
	$"../inventory".visible = false
	$"../binder".visible = false

	Player.inInventory = false

	for key in Player.cardInventory:
		Player.cardInventory[key].visible = false
	for key in Player.binder:
		Player.binder[key].visible = false
