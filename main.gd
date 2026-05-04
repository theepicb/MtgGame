extends Node2D
const SAVE_PATH = "user://game_data.json"


var version = 0.1


### Closing Game function
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Game is closing...")
		# moves cards from pack opening to inventory
		for card in Player.cardsToShow:
			if !(card is Sprite2D):
				continue
			if Player.cardInventory.has(card.ID):
				Player.cardInventory.get(card.ID).count += 1;
			else:
				Player.cardInventory[card.ID] = card
		for child in Player.cardsToShow:
			if is_instance_valid(child):
				child.queue_free()
		
		# finishing closing
		Player.cardsToDelete.clear()
		$CanvasLayer/level_Label.setText()
		Player.checkLevel()
		save_game()
		get_tree().quit()

# function to save game
func save_game():
	var data = {
		"version": version,
		"Money_Clicker": $Money_Clicker.returnDictionary(),
		"pack_clicker": $Pack_Clicker.returnDictionary(),
		"Player": Player.returnDictionary(),
		"Upgrades": {
			"avaliable": $Upgrades/Upgrade_Data.returnDictionaryAvaliable(),
			"purchased": $Upgrades/Upgrade_Data.returnDictionaryPurchased()
		},
		"Luck": {
			"player_luck": Player.luck,
		},
		"Packs": get_node("/root/Main/Pack_Screen").returnDictionary(),
		"Achievements": $Achievements.returnDictionary(),
		"PackData": $Pack_Data.returnDictionary()
		
		
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	pass

# function to load game, if file is not found starts defultLoad
func loadGame ():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No Save Data Found")
		return  null
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var file_content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(file_content)
		
		return data
	
	else: return null;

func implamentData (data: Dictionary):
	await get_tree().create_timer(1).timeout
	updateData(data.get("version", version))
	Player.setDictionary(data["Player"])
	$Money_Clicker.updateText()
	$CanvasLayer/level_Label.setText()
	var avaliableUpgrades = data["Upgrades"].get("avaliable", [])
	var purchasedUpgrades = data["Upgrades"].get("purchased", [])
	$Upgrades/Upgrade_Data.createUpgrades(avaliableUpgrades)
	$Upgrades/Upgrade_Data.createPurchasedUpgrades(purchasedUpgrades)
	$Achievements.setDictionary(data["Achievements"])
	$Pack_Screen.setDictionary(data["Packs"])
	$Money_Clicker.setDictionary(data["Money_Clicker"])
	$Pack_Data.setDictionary(data["PackData"])
	$Pack_Clicker.setDictionary(data["pack_clicker"])
	pass



func defultLoad ():
	$Upgrades/Upgrade_Data.start()
	save_game();

func _ready() -> void:
	$CanvasLayer/Click_Screen_button.visible = false
	$CanvasLayer/Upgrades_Button.visible = false
	$Money_Clicker.visible = false
	$Pack_Clicker.visible = false
	$CanvasLayer/Upgrades_Button.visible = false
	$CanvasLayer/Pack_Screen_Button.visible = false
	$CanvasLayer/Open_Packs_Screen.visible = false
	$CanvasLayer/Inventory_Button.visible = false
	$CanvasLayer/level_Label.visible = false
	$CanvasLayer/Upgrade_Tree_button.visible = false
	if not FileAccess.file_exists("user://game_data.json"):
		defultLoad()
		pass
	else:
		var loading = loadGame()
		if loading != null:
			await implamentData(loading)
		else:
			defultLoad()
	$Money_Clicker.visible = true
	$Pack_Clicker.visible = true
	$CanvasLayer/Click_Screen_button.visible = true
	$CanvasLayer/Upgrades_Button.visible = true
	$CanvasLayer/Upgrades_Button.visible = true
	$CanvasLayer/Pack_Screen_Button.visible = true
	$CanvasLayer/Open_Packs_Screen.visible = true
	$CanvasLayer/Inventory_Button.visible = true
	$CanvasLayer/level_Label.visible = true
	#$CanvasLayer/Upgrade_Tree_button.visible = true
	listChildren(self, 0)
	
	pass

func listChildren (node: Node, layer: int):
	print("-".repeat(layer),  node.name)
	for child in node.get_children():
		listChildren(child, layer + 1)


func updateData(dataVersion):
	while dataVersion != version:
		if dataVersion == 0.1:
			print("version = 0.1")
			
