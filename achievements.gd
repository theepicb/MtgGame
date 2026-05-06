extends Node2D

@onready var upgrade_manager = get_node("/root/Main/Upgrades/Upgrade_Data")

var xpRequired = [50, 125, 275, 615, 1250, 2750, 6150, 9999999]

var data = {
	"woe": {
		"name": "woe",
		"xp": 0,
		"level": 1,
	},
	"rvr": {
		"name": "rvr",
		"xp": 0,
		"level": 1,
	}
}

func _ready() -> void:
	returnDictionary()

func outsideCall (set_name: String, amount: float):
	if (!data.has(set_name)) : printerr("set name not found")
	data[set_name].xp += amount
	checkAchievement(data[set_name])

func checkAchievement(input: Dictionary):
	if (input["xp"] >= xpRequired[input["level"]]):
		input["xp"] -= xpRequired[input["level"]]
		input["level"] += 1
		print("leveled up %s to level %d", input["name"], input["level"])

func achievement_handler(Packname: String, ID: int):
	print("ach called")
	match Packname:
		"woe":
			match ID:
				0:
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_d0"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_s0"))
				1: 
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_d1"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_s1"))
				2:
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_d2"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_s2"))
				3:
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_d3"))
					upgrade_manager.generateNewUpgrade(upgrade_manager.upgradeMain.get("woe_s3"))


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
		if item != "foilAch" and item != "itemAch" and data.has(item):
			data[item]["xp"] = input[item]["xp"]
			data[item]["level"] = input[item]["level"]
	pass

func getItemAch (item: String):
		upgrade_manager.generateNewUpgrade(upgrade_manager.cardAchUpgrades.get(item))
