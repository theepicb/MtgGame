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
			"inventory": $Player.inventory,
			"money": $Player.money
		}
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
	
	pass

func _ready() -> void:
	if not FileAccess.file_exists("user://game_data.json"):
		$Player.money = 0;
		$Player.inventory = [];
		$Money_Clicker.money_per_click = 0.01;
		$Money_Clicker.combo_wait_time = 1;
		$Money_Clicker.money_multiplier = 1;
		save_game();
		pass
	
	var screen = 0;
	pass
