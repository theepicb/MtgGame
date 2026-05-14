extends Button

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	global_position = Vector2(200, 5)
	text = "Sell All"

func _pressed() -> void:
	if $"../Inventory_Button".inventoryScreen == 0:
		var amount = 0
		for key in Player.cardInventory:
			var card = Player.cardInventory[key]
			amount += card.price * card.count * Player.sell_multi
			card.visible = false
		Player.money += amount
		Player.cardInventory.clear()
		$"../Inventory_Button".loadInventory()
		$"../level_Label".setText()
		$"../../Money_Clicker".updateText()
