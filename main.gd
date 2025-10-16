extends Node2D
const SAVE_PATH = "user://game_data.json"


var version = 0.1

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Called when the user tries to close the window
		print("Game is closing...")
		save_game()
		get_tree().quit()

func save_game():
	var inv = []
	
	for item in Player.cardInventory:
		inv.append(item.returnDictionary())
	
	var data = {
		"version": version,
		"Money_Clicker": {
			"money_per_click": $Money_Clicker.money_per_click,
			"combo_wait_time": $Money_Clicker.combo_wait_time,
			"money_per_second": $Money_Clicker.money_per_second
		},
		"Player": {
			"inventory": inv,
			"money": Player.money,
			"xp": Player.xp,
			"level": Player.level,
		},
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
	updateData(data["version"])
	# inventory load
	var inv = data["Player"].get("inventory", [])
	loadInv(inv)
	Player.money = data["Player"].get("money", 0)
	$Money_Clicker.updateText()
	Player.xp = data["Player"].get("xp", 0)
	Player.level = int(data["Player"].get("level", 1))
	$CanvasLayer/level_Label.setText()
	var avaliableUpgrades = data["Upgrades"].get("avaliable", [])
	var purchasedUpgrades = data["Upgrades"].get("purchased", [])
	$Upgrades/Upgrade_Data.createUpgrades(avaliableUpgrades)
	$Upgrades/Upgrade_Data.createPurchasedUpgrades(purchasedUpgrades)
	$Achievements.setDictionary(data["Achievements"])
	$Pack_Screen.setDictionary(data["Packs"])
	$Money_Clicker.money_per_click = data["Money_Clicker"].get("money_per_click", 0.01)
	$Money_Clicker.combo_wait_time = data["Money_Clicker"].get("combo_wait_time", 1)
	$Money_Clicker.money_per_second = data["Money_Clicker"].get("momey_per_second", 0)
	$Pack_Data.setDictionary(data["PackData"])
	pass

func loadInv(list: Array):
	for item in list:
		var tempCard = Card.new(item["count"], item["ID"], item["foil"], item["image_path"], Vector2(0, 0), item["serial"], item["serialNum"], item["serialMax"])
		if item["serial"]:
			tempCard.serialise(item["serialNum"], item["serialMax"])
		tempCard.setPrice(item["price"])
		tempCard.setName(item["cardName"])
		tempCard.loadImage()
		Player.add_child(tempCard)
		Player.cardInventory.append(tempCard)
		pass
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
	if not FileAccess.file_exists("user://game_data.json"):
		defultLoad()
		pass
	else:
		var loading = loadGame()
		if loading != null:
			await implamentData(loading)
		else:
			defultLoad()
	var screen = 0;
	$Money_Clicker.visible = true
	$Pack_Clicker.visible = true
	$CanvasLayer/Click_Screen_button.visible = true
	$CanvasLayer/Upgrades_Button.visible = true
	$CanvasLayer/Upgrades_Button.visible = true
	$CanvasLayer/Pack_Screen_Button.visible = true
	$CanvasLayer/Open_Packs_Screen.visible = true
	$CanvasLayer/Inventory_Button.visible = true
	$CanvasLayer/level_Label.visible = true
	pass

func updateData(dataVersion):
	while dataVersion != version:
		if dataVersion == 0.1:
			print("version = 0.1")
