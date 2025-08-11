extends CanvasLayer
func _ready() -> void:
	print("Canvas parent:", get_parent())
	print("Current scene:", get_tree().current_scene)

func resetInv():
	$Inventory_Button.loadInventory()
	
