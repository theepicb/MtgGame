extends Node2D

var money = 0;
var luck = 0;
var spg_luck = 2
var list_luck = 2

var tix = 0;

var level = 1;
var xpToLevelUp = [0, 5, 20, 50, 90, 150, 250, 400, 600, 850, 1200, 9999999]
var xp = 0;
var sell_multi = 0.25

var common = []
var uncommon = []
var rare = []
var mythic = []
var signet = []
var phy_transform = []
var common_trans = []
var uncommon_trans = []
var rare_trans = []
var mythic_trans = []

@onready var upgradeData = get_node("/root/Main/Upgrades/Upgrade_Data")
@onready var levelLabel = get_node("/root/Main/CanvasLayer/level_Label")
func levelUp (_level: int):
	match _level:
		2:
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PU1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("MP1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CC1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PP1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("SM1"))
		3:
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("MC1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("MP2"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PM1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PU6"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CU4"))
		4:
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CC2"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("SM2"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CU1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CM1"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("MC2"))
		5:
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("CU3"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PU2"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PU4"))
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("Pl1"))
		6:
			upgradeData.generateNewUpgrade(upgradeData.UpgradeMain.get("PU7"))
	levelLabel.setText()
			

func checkLevel ():
	if xp >= xpToLevelUp[level]:
		level += 1
		levelUp(level)
		checkLevel()

var inInventory = false;

static var instance = null

func _init():
	if instance != null:
		queue_free()  # Another instance exists, remove this one
		return
	instance = self

func reloadInv():
	var root = get_tree().current_scene  # this is your 'Main' node
	
	if root == null:
		print("No current scene loaded!")
		return
	
	var canvas_layer = root.get_node("CanvasLayer")
	if canvas_layer == null:
		print("CanvasLayer node not found!")
		return
	
	var inv_button = canvas_layer.get_node("Inventory_Button")
	if inv_button == null:
		print("Inventory_Button node not found!")
		return
	
	canvas_layer.resetInv()

var cardInventory = {};
var binder = {}
var IDbinder = []
var cardsToShow = [];
var cardsToDelete = [];
var sortedInventory = [];

func grabCard (number: int, foilEnum: int, posX: float, posY: float, isLast: bool, set_name: String, isGrabbing: bool = true) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new(number, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass

func returnDictionary() -> Dictionary:
	print()
	var inv = []
	var bin = []
	for key in Player.binder:
		var value = Player.binder[key]
		bin.append(value.returnDictionary())
		print("return value: ", value.returnDictionary())
	
	for key in Player.cardInventory:
		var value = Player.cardInventory[key]
		inv.append(value.returnDictionary())
		print("return value: ", value.returnDictionary())
	
	print("bin: ", bin)
	var dict = {
		"inventory": inv,
		"binder": bin,
		"money": money,
		"xp": xp,
		"level": level,
		"sell_multi": sell_multi,
		"specialGuestLuck": spg_luck,
		"list_luck": list_luck,
	}
	return dict

func setDictionary (dict: Dictionary):
	var inv = dict.get("inventory", [])
	loadInv(inv)
	Player.xp = dict.get("xp", 0)
	Player.level = int(dict.get("level", 1))
	Player.money = dict.get("money", 0)
	var bin = dict.get("binder", [])
	loadBinder(bin)
	Player.IDbinder = dict.get("IDbinder", [])
	Player.sell_multi = dict.get("sell_multi", 0.25)
	Player.spg_luck = dict.get("specialGuestLuck", spg_luck)
	Player.list_luck = dict.get("list_luck", 2)
	pass

func loadBinder(list: Array):
	print(list)
	for item in list:
		var tempCard = Card.new(item["count"], item["ID"], item["foil"], item["image_path"], Vector2(0, 0), item["serial"], item["serialNum"], item["serialMax"])
		if item["serial"]:
			tempCard.serialise(item["serialNum"], item["serialMax"])
		tempCard.setPrice(item["price"])
		tempCard.setName(item["cardName"])
		if !tempCard.loadImage():
			await tempCard.redownload()
			tempCard.loadImage()
		Player.add_child(tempCard)
		Player.binder[item["ID"]] = tempCard
		pass
	pass

func loadInv(list: Array):
	for item in list:
		var tempCard = Card.new(item["count"], item["ID"], item["foil"], item["image_path"], Vector2(0, 0), item["serial"], item["serialNum"], item["serialMax"])
		if item["serial"]:
			tempCard.serialise(item["serialNum"], item["serialMax"])
		tempCard.setPrice(item["price"])
		tempCard.setName(item["cardName"])
		if !tempCard.loadImage():
			await tempCard.redownload()
			tempCard.loadImage()
		Player.add_child(tempCard)
		Player.cardInventory[item["ID"]] = tempCard
		pass
	print("Player inv: ",Player.cardInventory)
	pass
