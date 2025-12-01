extends Button

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	global_position = Vector2(400, 5)
	text = "Inventory"

func _pressed() -> void:
	$"../VScrollBar".value = 0
	$"../Inventory_Button".currentInv = 0
	for x in Player.binder:
		x.visible = false
	$"../Inventory_Button".loadInventory()
