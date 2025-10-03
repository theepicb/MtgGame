extends Button

var Casino_Luck = 1

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Inventory_Button".leaveInventory();
	var button = Button.new()
	button.position = Vector2(100, 100)
	button.size = Vector2(160, 80);
	button.connect("pressed", Callable(self, "loadCasino").bind(Casino_Luck));

func loadCasino (luck):
	var x = randf_range(0, 100)
	var output = ((5 * (x + 8))/ (0.35 * (x + 8) - 2.5)) - 14.5
	print(x, " ", output)
