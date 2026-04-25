extends Control

func _ready() -> void:
	visible = false;
	size = Vector2(160, 80);
	
	pass

func _pressed():
	$"../../Achievements".cardAchieve(Player.cardsToShow)
	for x in Player.cardsToShow:
		x.visible = false;
		pass
	$"../Open_Packs_Screen".showUI()
	visible = false;
	for x in Player.cardsToDelete:
		if x is VBoxContainer:
			Player.cardsToDelete.erase(x)
			if is_instance_valid(x):
				x.queue_free()
			continue
		
		if Player.cardInventory.has(x.ID):
			Player.cardInventory[x.ID].count += 1
				
	for child in Player.cardsToDelete:
		if is_instance_valid(child):
			child.queue_free()
	Player.cardsToDelete.clear()
	Player.cardsToShow.clear();
	$"../level_Label".setText()
	Player.checkLevel()
	$"../VScrollBar_PackOpening".visible = false;
	$"../..".save_game()
	pass

func draw() -> void:
	position = Vector2((get_viewport_rect().size.x / 2) - 80, get_viewport_rect().size.y - 85);
	visible = true;
	print("drawing Back button")
	pass
