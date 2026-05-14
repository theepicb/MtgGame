extends Node2D
var set_name = "mat"

var uncommon = [1, 3, 7, 8, 12, 13, 14, 17, 19, 20, 25, 27, 28, 30, 31]
var rare = [2, 4, 5, 6, 9, 10, 11, 15, 16, 18, 21, 23, 24, 29, 32, 33, 34, 37, 39, 40, 42, 43, 44, 47, 50]
var mythic = [22, 26, 35, 36, 38, 41, 45, 46, 48, 49]
var specialUncommon = [51, 53, 57, 58, 62, 63, 64, 67, 69, 70, 75, 77, 78, 79, 80, 81]
var specialRare = [52, 54, 55, 56, 59, 60, 61, 65, 66, 68, 71, 73, 74, 82, 83, 84, 87, 89, 90, 92, 93, 94, 97, 100]
var specialMythic = [72, 76, 85, 86, 88, 91, 95, 96, 98, 99]
var etchedUncommon = [101, 103, 107, 108, 112, 113, 114, 117, 119, 120, 125, 127, 128, 130, 131]
var etchedRare = [102, 104, 105, 106, 109, 110, 111, 115, 116, 118, 121, 123, 124, 129, 132, 133, 134, 137, 139, 140, 142, 143, 144, 147, 150, ]
var etchedMythic  = [122, 126, 135, 136, 138, 141, 145, 146, 148, 149]
var extendedRare = [151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 163, 164, 166, 167, 168, 169, 172, 174, 175, 177, 178, 179, 182, 185]
var extendedMythic = [162, 165, 170, 171, 173, 176, 180, 181, 183, 184]
var halouncommon = [186, 188, 191, 192, 196, 197, 208]
var halorare = [200, 195, 209, 187, 228, 212, 189, 216, 218, 219, 221, 202, 222, 223, 226, 190, 213, 193, 204, 199, 194]
var halomythic = [196, 207, 186,  197, 210, 191, 211, 188, 201, 198, 203, 192, 205, 206, 214, 215, 217, 220, 224, 227, 225]

var draft_luck = 0;
var collector_luck = 0;
var list_chance = 0;
var col_double_open = 100

func setDictionary (dict: Dictionary) -> void:
	draft_luck = dict.get("draft", 0)
	collector_luck = dict.get("collector", 0)
	list_chance = dict.get("list_chance", 0)
	col_double_open = dict.get("double_open", 0)
	pass

func returnDictionary () -> Dictionary:
	var dictionary = {}
	dictionary["draft"] = draft_luck
	dictionary["collector"] = collector_luck
	dictionary["list_chance"] = list_chance
	dictionary["double_open"] = col_double_open
	return dictionary

func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	preload("res://Card_Grabber.gd")
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	add_child(grab)
	pass

func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass

func _ready() -> void:
	#grabCard(halouncommon, 1, 0, 0, true)
	$"..".ensure_directory_exists("user://Cards/mat")
	#grabCardExtra(94,1, 0, 0, true, false)
	pass

func createDraftPack () -> void: 
	# init -------------------------------------------------
	var list = false
	if (Lib.doesPass(draft_luck, 100-list_chance)):
		list = true
	# pack --------------------------------------------------
	var counter = 0
	for x in 2:
			Lib.grabCardEasy(set_name, uncommon, 0, counter, false)
		
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([rare, mythic], [84, 16]), 0, counter, false)
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([specialUncommon, specialRare, specialMythic], [50, 34, 16]), 0, counter, false)
	
	var foil = 0;
	if (Lib.doesPass(0, 84)):
		foil = 1; 
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([specialRare, specialMythic], [84, 16]), foil, counter, !list)
	
	if list:
		var list_card = P_list.new(counter, true)
		add_child(list_card)
	
	Lib.finish()

func createCollectorPack (doubleOpen: bool = false, doubleCounter: int = 1):
	var openAgain = false
	if (Lib.doesPass(0, 100 - (col_double_open / doubleCounter))):
		openAgain = true
	var counter = 0;
	
	Lib.grabCardEasy(set_name, specialUncommon, 1, counter, false)
	
	Lib.grabCardEasy(set_name, etchedUncommon, 2, counter, false)
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([rare, mythic], [84, 16]), 1, counter, false)
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([rare, mythic], [84, 16]), 1, counter, false)
	
	var foil = 0
	if Lib.doesPass(0, 84):
		foil = 1
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([extendedRare, extendedMythic], [84, 16]), foil, counter, false)
	
	if $"..".getLuck() >= 84:
		Lib.grabCardEasy(set_name, etchedMythic, 2, counter, false)
	else:
		Lib.grabCardEasy(set_name, etchedRare, 2, counter, false)
	
	var halo = false
	if Lib.doesPass(0, 84):
		halo = true
	
	if halo:
		Lib.grabCardEasy(set_name, Lib.getRarityByWeight([halouncommon, halorare, halomythic], [50, 34, 16]), 1, counter, !openAgain)
	else:
		Lib.grabCardEasy(set_name, Lib.getRarityByWeight([specialUncommon, specialRare, specialMythic], [50, 34, 16]), 1, counter, !openAgain)
	
	if openAgain:
		createCollectorPack(true, doubleCounter + 1)
	else:
		Lib.finish()
