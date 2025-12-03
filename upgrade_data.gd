extends UpgradeManager

func start() -> void:
	generateNewUpgrade(clickerUpgrades.get("CU0"))
	generateNewUpgrade(MPSUpgrades.get("MP1"))



func generateNewUpgrade (array: Array):
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
		"whenever you click for money theres a 1/5 chance you also click for a pack",
		100,
		func ():
			$"../../Money_Clicker".rhysticUpgrade = true
			return true
],
	"confettiFoil": [
		"confettiFoil",
		"increases your chances of getting confetti foils from Wilds of Eldraine collector boosters",
		100,
		func ():
			$"../../Pack_Data/Woe_data".confetti_luck += 0.5
			return true
],
}

var clickerUpgrades = {
"CU0": 
	["CU0", 
	"increase click value +0.01c per click", 
	1.5, 
	func (): 
		increaseClickerValue(0.01)
		generateNewUpgrade(clickerUpgrades.get("CU1"))
		return true],
"CU1": ["CU1",
	"increase click value +0.01c per click", 
	7.5,
	func (): 
		increaseClickerValue(0.01)
		return true],
"CU2": ["CU2",
	"increase click value +0.01c per click", 
	25,
	func (): 
		increaseClickerValue(0.01)
		return true],
"CU3": ["CU3",
	"increase click value +0.01c per click", 
	50,
	func (): 
		increaseClickerValue(0.01)
		return true
],
"CC1": ["CC1",
	"increases your chance to critical click by 3%", 
	15,
	func (): 
		$"../../Money_Clicker".crit_chance += 3
		return true
],
"CC2": ["CC2",
	"increases your chance to critical click by 3%", 
	30,
	func (): 
		$"../../Money_Clicker".crit_chance += 3
		return true
],
"CC3": ["CC3",
	"increases your chance to critical click by 2%", 
	60,
	func (): 
		$"../../Money_Clicker".crit_chance += 2
		return true
],
"CM1": ["CM1",
	"increases your crit multi by +0.2x", 
	20,
	func (): 
		$"../../Money_Clicker".crit_multi += 2
		return true
],
"CM2": ["CM2",
	"increases your crit multi by +0.2x", 
	55,
	func (): 
		$"../../Money_Clicker".crit_multi += 2
		return true
],
}


var packUpgrades = {
	## pack unlocks upgrades
	##################################################
	##################################################
	"PU0": [
	"PU0",
	"Unlocks March of the Machine: Aftermath Collector Boosters",
	10,
	func ():
		registorPack("mat_col", "uncommon")
		return true
],
	"PU1": [
		"PU1",
		"Unlocks Wilds of Eldraine Draft Packs",
		5,
		func ():
			registorPack("woe_draft", "common")
			return true
			],
	"PU2": [
		"PU2",
		"Unlocks Wilds of Eldraine Set Packs",
		15,
		func ():
			registorPack("woe_set", "uncommon")
			return true
			],
	"PU3": [
		"woe_s1",
		"increases your overall luck",
		20,
		func ():
			Player.luck += 0.01
			return true
],
	"PU4": [
		"PU4",
		"unlocks ravnica remastered draft packs",
		25,
		func ():
			registorPack("rvr_draft", "uncommon")
			return true
],
	"PU5": [
		"PU5",
		"unlocks ravnica remastered collector booster packs",
		40,
		func ():
			registorPack("rvr_col", "epic")
			return true
],
	"PU6": [
		"PU6",
		"unlocks march of the machine draft packs",
		15,
		func ():
			registorPack("mom_draft", "common")
			return true
],
"PU7": [
		"PU7",
		"unlocks march of the machine set packs",
		30,
		func ():
			registorPack("mom_draft", "common")
			return true
],
"PU8": [
		"PU8",
		"unlocks march of the machine collector packs",
		80,
		func ():
			registorPack("mom_draft", "epic")
			return true
],
}

var MPSUpgrades = {
	## Money per second upgrades
	##################################################
	##################################################
	"MP0": [
	"MP0",
	"increases money per second by 0.01c",
	2.5,
	func ():
		increaseMPSValue(0.01)
		return true
],
"MP1": [
	"MP1",
	"increases money per second by 0.01c",
	5,
	func ():
		increaseMPSValue(0.01)
		return true
],
"MP2": [
	"MP2",
	"increases money per second by 0.01c",
	17.5,
	func ():
		increaseMPSValue(0.01)
		return true
],
}

var packOpeningUpgrades = {
	## Wilds of eldraine draft
	##################################################
	##################################################
	"woe_d0": [
		"woe_d0",
		"increases your odds with wilds of eldraine draft packs slightly",
		10,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.02
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
 "woe_d1": [
		"woe_d1",
		"increases your odds with wilds of eldraine draft packs even more",
		25,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.02
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
"woe_d2": [
		"woe_d2",
		"increases your odds with wilds of eldraine draft packs by a lot",
		50,
		func ():
			$"../../Pack_Data/Woe_data".draft_luck += 0.02
			print($"../../Pack_Data/Woe_data".draft_luck)
			return true
],
"woe_d3": [
	"woe_d3",
	"decreases price of wilds of eldraine draft packs by $1.50 and increases your luck further",
	65,
	func ():
		for pack in PackManager.instance.packs:
			if pack.id == "woe_draft":
				pack.price -= 1.5
		$"../../Pack_Data/Woe_data".draft_luck += 0.02
		return true
],
"woe_d4": [
	"woe_d4",
	"adds a slight chance to get anime cards or confetti foils at the end of the pack",
	120,
	func ():
		$"../../Pack_Data/Woe_data".draft_conf_luck += 1;
		return true
],

## Wilds of eldraine set
##################################################
##################################################
"woe_s0": [
	"woe_s0",
	"slightly increases luck in wilds of eldraine set boosters",
	12.5,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		return true
],
"woe_s1": [
	"woe_s1",
	"slightly increases luck in wilds of eldraine set boosters and gives a chance for a bonus foil card",
	30,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		$"../../Pack_Data/Woe_data".set_bonus_foil += 1
		return true
],
"woe_s2": [
	"woe_s2",
	"slightly increases luck in wilds of eldraine set boosters and gives an extra chance for a bonus foil card",
	60,
	func ():
		$"../../Pack_Data/Woe_data".set_luck += 0.01
		$"../../Pack_Data/Woe_data".set_bonus_foil += 1.5
		return true
],
"woe_s3": [
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

var playerUpgrades = {
"Pl1": [
	"PL1",
	"slightly increases your over all luck",
	30,
	func ():
		Player.luck += 0.015
		return true
],
"Pl2": [
	"P21",
	"slightly increases your over all luck",
	80,
	func ():
		Player.luck += 0.015
		return true
],
}

var packClicker = {
"PP1": [
	"PP1",
	"slightly increases your pack progress per click",
	5,
	func ():
		$"../../Pack_Clicker".completionPerClick += 0.5
		return true
],
"PA1": [
	"PA1",
	"slightly increases your pack progress per second",
	15,
	func ():
		$"../../Pack_Clicker".autoCompletion += 0.1
		return true
],
"PM1": [
	"PM1",
	"increases your max progression for the pack clicker",
	7.5,
	func ():
		$"../../Pack_Clicker".maxCompletion += 10
		return true
],
"PL1": [
	"PL1",
	"increases your luck for the pack clicker",
	7.5,
	func ():
		$"../../Pack_Clicker".packLuck += 1
		return true
],
"PL2": [
	"PL2",
	"increases your luck for the pack clicker",
	12.5,
	func ():
		$"../../Pack_Clicker".packLuck += 1
		return true
],
"PL3": [
	"PL3",
	"increases your luck for the pack clicker",
	17.5,
	func ():
		$"../../Pack_Clicker".packLuck += 1
		return true
],
}

func returnDictionaryAvaliable ():
	var array = []
	for item in $"..".available_upgrades:
		array.append(item.id)
	return array

func returnDictionaryPurchased ():
	var array = []
	for item in $"..".purchased_upgrades:
		array.append(item.id)
	return array

func createUpgrades(saved_array: Array):
	if saved_array.is_empty():
		return
	
	var combined = {}

	for d in [cardAchUpgrades, clickerUpgrades, packUpgrades, MPSUpgrades, packOpeningUpgrades, playerUpgrades, packClicker]:
		for key in d.keys():
			combined[key] = d[key]

	#print(combined)
	for savedID in saved_array:
		if combined.has(savedID):
			#print(combined.get(savedID))
			generateNewUpgrade(combined.get(savedID))

func createPurchasedUpgrades(saved_array: Array):
	
	var combined = {}

	for d in [cardAchUpgrades, clickerUpgrades, packUpgrades, MPSUpgrades, packOpeningUpgrades, playerUpgrades, packClicker]:
		for key in d.keys():
			combined[key] = d[key]

	#print(combined)
	for savedID in saved_array:
		if combined.has(savedID):
			#print(combined.get(savedID))
			var array = combined.get(savedID)
			var upgrade = Upgrade.new(array[0], array[2], array[1], array[3])
			$"..".purchased_upgrades.append(upgrade)
