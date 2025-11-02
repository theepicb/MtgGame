extends Button

var upgrades = []

func _ready() -> void:
	visible = false
	size = Vector2(180, 60)
	position = Vector2(2, 305)
	text = "Rank"
	var U01 = UpgradeNode.new(Vector2(get_viewport_rect().size.x / 2, 0), [])
	add_child(U01)
	upgrades.append(U01)
	self.queue_free()
	

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	$"../Open_Packs_Screen".deleteChildren();
	$"../Inventory_Button".leaveInventory();
	for child in upgrades:
		child.show()
	

func createNewTree(posx, posy, children: Array):
	var new = UpgradeNode.new(Vector2(posx, posy), children)
	add_child(new)
