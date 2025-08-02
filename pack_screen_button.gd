extends Button

func _ready() -> void:
	position = Vector2(2, 125);
	size = Vector2(180, 60);
	text = "Packs";
	pass

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".layout_pack_buttons();
	pass
