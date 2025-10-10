extends Node2D

@onready var upgrade_manager = get_node("/root/Main/Upgrades/Upgrade_Data")

var data = {
	"woe_draft": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_draft", data["woe_draft"]["achieNumber"]); data["woe_draft"]["achieNumber"] += 1
	},
	"woe_set": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func (): achievement_handler("woe_set", data["woe_set"]["achieNumber"]); data["woe_set"]["achieNumber"] += 1
	},
	"woe_collector": {
		"amounts": [2, 5, 10, 25, 50, 999999],
		"achieNumber": 0,
		"numberOpened": 0,
		"function": func(): achievement_handler("woe_col", data["woe_collector"]["achieNumber"]); data["woe_collector"]["achieNumber"] += 1
	}
}

func _ready() -> void:
	checkAchievement(data["woe_draft"])
	returnDictionary()

func outsideCall (set_name: String):
	data[set_name].numberOpened += 1
	checkAchievement(data[set_name])

func checkAchievement(input: Dictionary):
	var achie_number = input["achieNumber"]
	var target_amount = input["amounts"][achie_number]
	print("brrrr", achie_number, target_amount, input["numberOpened"])
	if input["numberOpened"] >= target_amount:
		input["function"].call()
		print("called function")

func achievement_handler(name: String, ID: int):
	print("ach called")
	match name:
		"woe_draft":
			match ID:
				0:
					upgrade_manager.generateNewUpgrade(upgrade_manager.packUpgrades.get("PU2"))
				1:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_d0"))
				2: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_d1"))
				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_d2"))
				4:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_d3"))
		"woe_set":
			match ID:
				0: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.packUpgrades.get("PU3"))
				1:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_s0"))
				2:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_s1"))
				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_s2"))
				4:
					upgrade_manager.generateNewUpgrade(upgrade_manager.openingUpgradesWoe.get("woe_s3"))

var foilAch = ["confettiFoil"]
var itemAch = ["doubling season", "smothering tithe", "rhystic study", ]
func cardAchieve(items: Array):
	for item in items:
		print(item.cardName.to_lower())
		if itemAch.has(item.cardName.to_lower()):
			getItemAch(item.cardName.to_lower())
			itemAch.erase(item.cardName.to_lower())
		if item.foil == 3 && foilAch.has("confettiFoil"):
			foilAch.erase("confettiFoil")
			getItemAch("confettiFoil")




func returnDictionary ():
	var dict = {}
	for item in data.keys():
		dict[item] = {}
		dict[item]["achieNumber"] = data[item]["achieNumber"]
		dict[item]["numberOpened"] = data[item]["numberOpened"]
	return dict

func setDictionary (input: Dictionary):
	for item in input.keys():
		data[item]["achieNumber"] = input[item]["achieNumber"]
		data[item]["numberOpened"] = input[item]["numberOpened"]
	pass

func getItemAch (item: String):
		upgrade_manager.generateNewUpgrade(upgrade_manager.cardAchUpgrades.get(item))
