extends Button
func _ready() -> void:
	position = Vector2(2, 5);
	size = Vector2(180, 60);
	text = "Click!";
	pass


func _pressed() -> void:
	$"../../Money_Clicker".visible = true;
	$"../../Pack_Clicker".visible = true;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	pass
