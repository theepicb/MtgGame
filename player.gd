extends Node2D

var money = 500;
var luck = 1;

var level = 1;
var xpToLevelUp = [5, 20, 50, 100, 250, 500]
var xp = 0;

var common = []
var uncommon = []
var rare = []
var mythic = []


@onready var upgradeData = get_node("/root/Main/Upgrades/Upgrade_Data")
@onready var levelLabel = get_node("/root/Main/CanvasLayer/level_Label")
func levelUp (level):
	match level:
		2:
			upgradeData.generateNewUpgrade(upgradeData.packUpgrades, 0)
	levelLabel.setText()
			

func checkLevel ():
	if xp >= xpToLevelUp[level]:
		level += 1
		levelUp(level)

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


func grabCard (number: int, foilEnum: int, posX: float, posY: float, isLast: bool, set_name: String, isGrabbing: bool = true) -> void:
	var pos = Vector2(posX, posY)
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(number, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass
