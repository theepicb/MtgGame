extends UpgradeManager

func _ready() -> void:
	generateNewUpgrade(clickerUpgrades, 0)
	
	generateNewUpgrade(MPSUpgrades, 0)
	generateNewUpgrade(packUpgrades, 1)

func generateNewUpgrade (dict: Dictionary,id: int):
	var array = dict.get(id)
	print(array)
	var upgrade = Upgrade.new(array[0], array[2], array[1], array[3])
	$"..".register_upgrade(upgrade)
	pass

var cardAchUpgrades = {
	"doubling season": [
		"doublingSeason",
		"doubles your coins per click",
		100,
		func ():
			$"../../Money_Clicker".money_multiplier += 1
			return true
],
	"smothering tithe": [
		"smotheringTithe",
		"increases your coins per click and coins per second by $0.05",
		100,
		func ():
			$"../../Money_Clicker".money_per_click += 0.05
			$"../../Money_Clicker".money_per_second += 0.05
			return true
],

	"rhystic study": [
		"rhysticStudy",
		"increases your coins per click and coins per second by $0.05",
		100,
		func ():
			
			return true
],
}

var clickerUpgrades = {
0: 
	["CU0", 
	"increase click value +0.01 per click", 
	5.0, 
	func (): 
		increaseClickerValue(0.01)
		generateNewUpgrade(clickerUpgrades, 1)
		return true],
1: ["CU1",
	"increase click value +0.01 per click", 
	7.5,
	func (): 
		increaseClickerValue(0.01)
		return true]}

var packUpgrades = {
	0: [
	"PU0",
	"Unlocks March of the Machine: Aftermath Collector Boosters",
	10,
	func ():
		registorPack("mat_col", "uncommon")
		return true
],
	1: [
		"PU1",
		"Unlocks Wilds of Eldraine Draft Packs",
		5,
		func ():
			registorPack("woe_draft", "common")
			return true
			],
	2: [
		"PU2",
		"Unlocks Wilds of Eldraine Set Packs",
		5,
		func ():
			registorPack("woe_set", "uncommon")
			return true
			],
	3: [
		"woe_s1",
		"unlocks collector boosters",
		20,
		func ():
			registorPack("woe_col", "uncommon")
			return true
]
}

var MPSUpgrades = {
	0: [
	"MP0",
	"increases money per second by 0.01c",
	2.5,
	func ():
		increaseMPSValue(0.01)
		return true
]}

var openingUpgradesWoe = {
	0: [
		"woe_d0",
		"increases your odds with wilds of eldraine draft packs slightly",
		10,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.01
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
 1: [
		"woe_d1",
		"increases your odds with wilds of eldraine draft packs even more",
		25,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.01
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
2: [
		"woe_d2",
		"increases your odds with wilds of eldraine draft packs by a lot",
		50,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.02
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
3: [
	"woe_d3",
	"decreases price of wilds of eldraine draft packs by $1.50 and increases your luck further",
	70,
	func ():
		for pack in PackManager.instance.packs:
			if pack.id == "woe_draft":
				pack.price -= 1.5
		$"../../Pack_Data/Woe_data".draft_luck += 0.02
		return true
],
4: [
	"woe_s0",
	"slightly increases luck in wilds of eldraine set boosters",
	12.5,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		return true
],

5: [
	"woe_s1",
	"slightly increases luck in wilds of eldraine set boosters and gives a chance for a bonus foil card",
	30,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		$"../../Pack_Data/Woe_data".set_bonus_foil += 1
		return true
],
6: [
	"woe_s2",
	"slightly increases luck in wilds of eldraine set boosters and gives an extra chance for a bonus foil card",
	60,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		$"../../Pack_Data/Woe_data".set_bonus_foil += 1.5
		return true
],
7: [
	"woe_s3",
	"increases luck in wilds of eldraine set boosters and gives an extra chance for a bonus foil card",
	85,
	func ():
		for pack in PackManager.instance.packs:
			if pack.id == "woe_set":
				pack.price -= 1.5
		$"../../Pack_Data/Woe_data".set_luck += 0.02
		$"../../Pack_Data/Woe_data".set_bonus_foil += 2.5
		return true
]
}
