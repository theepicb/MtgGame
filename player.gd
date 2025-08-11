extends Node2D

var money = 500;
var luck = 1;

var inInventory = false;

func _ready() -> void:
	print("hello world!")

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
