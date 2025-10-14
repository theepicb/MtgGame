extends Button

var Casino_Luck = 1

func _ready() -> void:
	size = Vector2(180, 60)
	position = Vector2(2, 305)

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Inventory_Button".leaveInventory();
	var button = Button.new()
	button.position = Vector2(100, 100)
	button.size = Vector2(160, 80);
	button.pressed.connect(loadCasino.bind(Casino_Luck))
	add_child(button)

func loadCasino (luck):
	var x = randf_range(0, 100)
	var output = ((5 * (x + 8))/ (0.35 * (x + 8) - 2.5)) - 15
	print(x, " ", output)
