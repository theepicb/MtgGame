extends Button

var inventoryScreen = 0

func _ready():
	size = Vector2(180, 60)
	position = Vector2(2, 245)
	text = "Inventory"
	pass 

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Open_Packs_Screen".deleteChildren();
	Player.inInventory = true;
	loadInventory();

func loadInventory () -> void:
	if Player.cardInventory.size() > 0:
		var amountInScreen = Player.cardInventory.size() % 24
		for x in amountInScreen:
			Player.cardInventory[(24 * inventoryScreen) + x].showCard(getPosition(x).x, getPosition(x).y)
		pass
	pass

func getPosition(x) -> Vector2:
	var pos = Vector2(285 + ((x % 8) * 205), 180 + (290 *(floor(x/ 8))))
	return pos

func leaveInventory () -> void:
	Player.inInventory = false
	for x in Player.cardInventory:
		x.visible = false;
