extends Node2D
const SAVE_PATH = "user://game_data.json"

func save_game():
	var data = {
		"Money_Clicker": {
			"money_per_click": $Money_Clicker.money_per_click,
			"combo_timer": $Money_Clicker.combo_wait_time,
			"money_per_second": $Money_Clicker.money_per_second
		},
		"Player": {
			"inventory": Player.cardInventory,
			"money": Player.money
		},
		"Upgrades": {
			"avaliable": get_node("/root/Main/Upgrades").available_upgrades,
			"purchased": get_node("/root/Main/Upgrades").purchased_upgrades
		},
		"Packs": get_node("/root/Pack_Screen").packs
			
		
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
		
		var data = JSON.parse_string(file)
		return data
	
	else: return null;
	
	return null;
	pass

func implamentData (data: Dictionary):
	Player.cardInventory = data["Player"].get("inventory", [])
	Player.money = data["Player"].get("money", 0)
	$Upgrades.available_upgrades = data["Upgrades"].get("avaliable", [])
	$Upgrades.purchased_upgrades = data["Upgrades"].get("purchased", [])
	$Money_Clicker.money_per_click = data["Money_Clicker"].get("money_per_click", 0.01)
	$Money_Clicker.combo_timer = data["Money_Clicker"].get("combo_wait_time", 1)
	$Money_Clicker.money_per_second = data["Money_Clicker"].get("momey_per_seceond", 0)
	pass

func defultLoad ():
	Player.money = 0;
	Player.inventory = [];
	$Money_Clicker.money_per_click = 0.01;
	$Money_Clicker.combo_wait_time = 1;
	$Money_Clicker.money_multiplier = 1;
	save_game();

func _ready() -> void:
	if not FileAccess.file_exists("user://game_data.json"):
		defultLoad()
		pass
	else:
		var loading = loadGame()
		if loading != null:
			implamentData(loading)
		else:
			defultLoad()
	var screen = 0;
	pass
