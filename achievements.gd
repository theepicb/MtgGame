extends Node2D

@onready var upgrade_manager = get_node("/root/Main/Upgrades/Upgrade_Data")

var data = {
	"woe_draft": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_draft", data["woe_draft"]["achieNumber"])
	},
	"woe_set": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_set", data["woe_set"]["achieNumber"])
	},
	"woe_collector": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_col", data["woe_collector"]["achieNumber"])
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
				2:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 0)
				3: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 1)
				4:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 2)
				5:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 3)
		"woe_set":
			match ID:
				1: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.packUpgrades, 3)
				2:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 4)
				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 5)
				4:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 6)
				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe, 7)

var itemAch = ["doubling_season", "smothing tithe"]
func cardAchieve(items: Array):
	for item in items:
		if itemAch.has(item):
			getItemAch(item)


func getItemAch (item: String):
		upgrade_manager.cardAchUpgrades(item)
