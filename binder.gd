extends Button

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	global_position = Vector2(600, 5)
	text = "Binder"

func _pressed() -> void:
	$"../VScrollBar".value = 0
	$"../Inventory_Button".inventoryScreen = 1
	for key in Player.cardInventory:
		Player.cardInventory[key].visible = false
	$"../Inventory_Button".loadInventory()
