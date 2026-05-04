extends Node2D

@onready var upgrade_manager = get_node("/root/Main/Upgrades/Upgrade_Data")

var xpRequired = [50, 125, 275, 615, 1250, 2750, 6150, 9999999]

var data = {
	"woe": {
		"xp": 0,
		"level": 1,
	},
	"rvr": {
		"xp": 0,
		"level": 1,
	}
}

func _ready() -> void:
	returnDictionary()

func outsideCall (set_name: String, amount: float):
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
		"woe":
			match ID:
				0:
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_d0"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_s0"))
				1: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_d1"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_s1"))

				2:
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_d2"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_s2"))

				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_d3"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.packOpeningUpgrades.get("woe_s3"))

			
var foilAch = ["confettiFoil"]
var itemAch = ["doubling season", "smothering tithe", "rhystic study", ]
func cardAchieve(items: Array):
	for item in items:
		if !(item is Sprite2D):
			continue
		print(item.cardName.to_lower())
		if itemAch.has(item.cardName.to_lower()):
			getItemAch(item.cardName.to_lower())
			itemAch.erase(item.cardName.to_lower())
		if item.foil == 3 && foilAch.has("confettiFoil"):
			foilAch.erase("confettiFoil")
			getItemAch("confettiFoil")




func returnDictionary ():
	var dict = {
		"foilAch": foilAch,
		"itemAch": itemAch
	}
	for item in data.keys():
		dict[item] = {}
		dict[item]["xp"] = data[item]["xp"]
		dict[item]["level"] = data[item]["level"]
	
	return dict

func setDictionary (input: Dictionary):
	foilAch = data.get("foilAch", foilAch)
	itemAch = data.get("itemAch", itemAch)
	for item in input.keys():
		if item != "foilAch" and item != "itemAch":
			data[item]["xp"] = input[item]["xp"]
			data[item]["level"] = input[item]["level"]
	pass

func getItemAch (item: String):
		upgrade_manager.generateNewUpgrade(upgrade_manager.cardAchUpgrades.get(item))
