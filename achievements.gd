extends Node2D

@onready var upgrade_manager = get_node("/root/Main/Upgrades/Upgrade_Data")

var data = {
	"woe_draft": {
		"amounts": [1, 5, 25],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_draft", data["woe_draft"]["achieNumber"])
	}
}

func _ready() -> void:
	checkAchievement(data["woe_draft"])
	

func outsideCall (set_name: String):
	data[set_name].numberOpened += 1
	checkAchievement(data[set_name])

func checkAchievement(input: Dictionary):
	for x in input["amounts"]:
		if input["numberOpened"] >= x:
			input["achieNumber"] += 1
			input["function"].call()
			print("called function")

func achievement_handler(name: String, ID: int):
	print("ach called")
	match name:
		"woe_draft":
			match ID:
				1:
					upgrade_manager.generateNewUpgrade(upgrade_manager.packUpgrades, 2)
