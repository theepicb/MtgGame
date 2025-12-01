extends Button

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	global_position = Vector2(600, 5)
	text = "Binder"

func _pressed() -> void:
	$"../VScrollBar".value = 0
	$"../Inventory_Button".currentInv = 1
	for x in Player.cardInventory:
		if is_instance_valid(x):
			x.visible = false
	$"../Inventory_Button".loadInventory()
