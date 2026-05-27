extends Button
func _ready():
	hide()
	size = Vector2(180, 60)
	position = Vector2(2, 185)
	text = "open packs"
	pass 

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Inventory_Button".leaveInventory();
	$"../Open_Packs_Screen".display_owned_packs();
	pass
