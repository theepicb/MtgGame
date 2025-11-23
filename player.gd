extends Node2D

var money = 50000;
var luck = 1;

var tix = 0;

var level = 1;
var xpToLevelUp = [0, 5, 20, 50, 90, 150, 250, 400, 600, 850, 1200, 9999999]
var xp = 0;


var common = []
var uncommon = []
var rare = []
var mythic = []
var signet = []
var phy_transform = []

@onready var upgradeData = get_node("/root/Main/Upgrades/Upgrade_Data")
@onready var levelLabel = get_node("/root/Main/CanvasLayer/level_Label")
func levelUp (_level: int):
	match _level:
		2:
			upgradeData.generateNewUpgrade(upgradeData.packUpgrades.get("PU1"))
			upgradeData.generateNewUpgrade(upgradeData.MPSUpgrades.get("MP1"))
			upgradeData.generateNewUpgrade(upgradeData.clickerUpgrades.get("CC1"))
		3:
			upgradeData.generateNewUpgrade(upgradeData.packClicker.get("PP1"))
			upgradeData.generateNewUpgrade(upgradeData.packUpgrades.get("PU2"))
		4:
			upgradeData.generateNewUpgrade(upgradeData.clickerUpgrades.get("CC2"))
			upgradeData.generateNewUpgrade(upgradeData.packUpgrades.get("PU0"))
		5:
			upgradeData.generateNewUpgrade(upgradeData.clickerUpgrades.get("CU3"))
		
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

var IDInventory = [];
var cardInventory = [];
var binder = []
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
	var inv = []
	var bin = []
	for item in Player.cardInventory:
		inv.append(item.returnDictionary())
	for item in Player.binder:
		bin.append(item.returnDictionary())
	var dict = {
		"inventory": inv,
		"binder": bin,
		"IDinv": IDInventory,
		"IDbinder": IDbinder,
		"money": money,
		"xp": xp,
		"level": level,
	}
	return dict

func setDictionary (dict: Dictionary):
	var inv = dict.get("inventory", [])
	loadInv(inv)
	Player.xp = dict.get("xp", 0)
	Player.level = int(dict.get("level", 1))
	Player.money = dict.get("money", 0)
	Player.IDInventory = dict.get("IDinv", [])
	var bin = dict.get("binder", [])
	loadBinder(bin)
	Player.IDbinder = dict.get("IDbinder", [])
	pass

func loadBinder(list: Array):
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
		Player.binder.append(tempCard)
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
		Player.cardInventory.append(tempCard)
		pass
	pass
