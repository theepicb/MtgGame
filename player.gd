extends Node2D

var money = 50000;
var luck = 1;

var tokens = 0;

var level = 1;
var xpToLevelUp = [5, 20, 50, 100, 250, 500, 999999]
var xp = 0;

var rankXp = 0
var rank = 0
var rankXpToLevelUp = [2, 5, 10, 20, 99999]

var common = []
var uncommon = []
var rare = []
var mythic = []
var signet = []

@onready var upgradeData = get_node("/root/Main/Upgrades/Upgrade_Data")
@onready var levelLabel = get_node("/root/Main/CanvasLayer/level_Label")
func levelUp (_level: int):
	match _level:
		2:
			upgradeData.generateNewUpgrade(upgradeData.packUpgrades.get("PU0"))
		3:
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
	
	for item in Player.cardInventory:
		inv.append(item.returnDictionary())
	var dict = {
		"inventory": inv,
		"money": money,
		"xp": xp,
		"level": level,
		"rank": rank,
		"rankXP": rankXp
	}
	return dict

func setDictionary (dict: Dictionary):
	var inv = dict.get("inventory", [])
	loadInv(inv)
	Player.xp = dict.get("xp", 0)
	Player.level = int(dict.get("level", 1))
	Player.money = dict.get("money", 0)
	pass

func loadInv(list: Array):
	for item in list:
		var tempCard = Card.new(item["count"], item["ID"], item["foil"], item["image_path"], Vector2(0, 0), item["serial"], item["serialNum"], item["serialMax"])
		if item["serial"]:
			tempCard.serialise(item["serialNum"], item["serialMax"])
		tempCard.setPrice(item["price"])
		tempCard.setName(item["cardName"])
		tempCard.loadImage()
		Player.add_child(tempCard)
		Player.cardInventory.append(tempCard)
		pass
	pass
