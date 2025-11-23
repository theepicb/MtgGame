extends Button

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	global_position = Vector2(200, 5)
	text = "Sell All"

func _pressed() -> void:
	if $"../Inventory_Button".currentInv == 0:
		var amount = 0
		for card in Player.cardInventory:
			amount += card.price * card.count
			card.visible = false
		Player.money += amount
		Player.cardInventory.clear()
		Player.IDInventory.clear()
		$"../Inventory_Button".loadInventory()
