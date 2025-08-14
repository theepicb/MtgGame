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
			registorPack("woe_draft", "rare")
			return true
]}

var MPSUpgrades = {
	0: [
	"MP0",
	"increases money per second by 0.01c",
	2.5,
	func ():
		increaseMPSValue(0.01)
		return true
]}
