extends Button

func _ready() -> void:
	position = Vector2(2, 65);
	size = Vector2(180, 60);
	text = "Upgrades"
	pass

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../Open_Packs_Screen".deleteChildren();
	$"../../Upgrades".create_upgrade_buttons();
	$"../../Pack_Screen".deleteChildren();
	pass
