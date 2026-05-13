extends Node2D

var set_name = "lci"
@onready var levelLabel = $"../../CanvasLayer/VScrollBar_PackOpening"
var draft_luck = 0
var set_luck = 0
var collector_luck = 0
var neon_luck = 0
var col_double_open = 0
var spg_luck = 0
var draft_spg_chance = 0


func returnDictionary () -> Dictionary:
	var dictionary = {}
	dictionary["draft"] = draft_luck
	dictionary["set"] = set_luck
	dictionary["collector"] = collector_luck
	dictionary["neon_luck"] = neon_luck
	dictionary["col_double_open"] = col_double_open
	dictionary["spg_luck"] = spg_luck
	dictionary["draft_spg_chance"] = draft_spg_chance
	return dictionary

func setDictionary (dict: Dictionary = {}) -> void:
	draft_luck = dict.get("draft", 0)
	set_luck = dict.get("set", 0)
	collector_luck = dict.get("collector", 0)
	neon_luck = dict.get("neon_luck", 0)
	col_double_open = dict.get("col_double_open", 0)
	spg_luck = dict.get("spg_luck", 0)
	draft_spg_chance = dict.get("draft_spg_chance", 0)
	pass

var common = [2, 3, 4, 7, 9, 11, 13, 15, 18, 24, 27, 28, 30, 31, 35, 37, 38, 40, 45, 46, 49, 53, 57, 64, 66, 68, 69, 70, 71, 72, 73, 75, 77, 82, 84, 85, 89, 90, 95, 99, 100, 101, 104, 105, 106, 109, 110, 112, 114, 116, 117, 118, 119, 130, 131, 132, 136, 138, 140, 142, 144, 149, 151, 154, 159, 160, 163, 166, 167, 168, 169, 172, 174, 175, 177, 182, 190, 192, 199, 200, 201, 202, 203, 205, 206, 207, 209, 210, 214, 218, 246, 248, 250, 253, 255, 259, 268, 273, 274, 275, 276, 277, 279]

var uncommon = [5, 8, 10, 16, 17, 19, 21, 22, 23, 25, 33, 42, 48, 50, 51, 54, 58, 59, 65, 74, 76, 78, 79, 86, 87, 91, 93, 96, 97, 102, 103, 107, 111, 120, 124, 125, 133, 139, 141, 143, 147, 148, 150, 152, 162, 165, 170, 173, 178, 179, 180, 183, 184, 186, 187, 194, 198, 213, 215, 216, 220, 224, 226, 227, 230, 232, 236, 242, 245, 247, 251, 252, 254, 260, 261, 263, 270, 272, 278, 286]

var rare = [1, 12, 14, 20, 34, 43, 44, 52, 61, 63, 80, 81, 94, 98, 113, 115, 121, 122, 123, 127, 137, 153, 156, 157, 161, 171, 176, 181, 191, 193, 196, 208, 211, 219, 221, 223, 225, 228, 234, 237, 241, 244, 258, 264, 265, 271, 280, 281, 282, 283, 284, 285]

var mythic = [32, 92, 134, 185, 212, 222, 229, 235, 238, 239, 240, 243, 249, 257, 269]

var trans_common = [29, 60, 128, 155, 197]

var trans_uncommon = [6, 36, 62, 83, 108, 129, 146, 164, 195, 217, 233, 262]

var trans_rare = [39, 41, 47, 56, 126, 135, 145, 188, 231, 256, 266, 267]

var trans_mythic = [26, 55, 67, 88, 158, 189, 204]

var show_unc = [298, 301, 302, 303, 304, 306, 310, 312]

var show_rare = [292, 293, 294, 295, 297, 299, 300]

var show_mythic = [305, 307, 308, 309, 311, 319]

var rare_oltec = ["333", "335", "337", "338", "342", "343", "344", "346", "347", "350", "349", "351", "348"]

var mythic_oltec = ["334", "336", "340", "345"]

var spg_unc = ["2", "5", "6", "7", "18"]

var spg_rare = ["1", "3", "4", "8", "9", "11", "16"]

var spg_mythic = ["10", "12", "13", "14", "15", "17"]

var rex = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20] 

func _ready() -> void:
	Lib.ensure_directory_exists(set_name)
	Lib.ensure_directory_exists("rex")
	for x in range(1, 19):
		Lib.grabCardExtra("spg", x, 0, 0, 0, false, true)
		await get_tree().create_timer(0.5).timeout
	Lib.grabCardExtra("spg", 1, 0, 0, 0, true, true)
	print("trans common ", Player.common_trans)
	print("trans uncommon ", Player.uncommon_trans)
	print("trans rare ", Player.rare_trans)
	print("trans mythic ", Player.mythic_trans)
	
func createDraftPack ():
	var counter = 0
	var cAmount = 9
	var foil = false
	if Lib.getLuck(draft_luck) >= 77:
		foil = true
		cAmount = 8
	var spg = false
	if (Lib.getLuck(0) > 100 - draft_spg_chance):
		spg = true
	
	for z in cAmount:
		Lib.grabCard(set_name, common, 0, Lib.getPosition(counter).x,Lib.getPosition(counter).y, false)
		counter += 1
	
	if foil:
		Lib.grabCard(set_name, common, 1, Lib.getPosition(counter).x,Lib.getPosition(counter).y, false)
		counter += 1
	
	for z in 3:
		Lib.grabCard(set_name, uncommon, 0, Lib.getPosition(counter).x,Lib.getPosition(counter).y, false)
		counter += 1
	
	if Lib.getLuck(draft_luck) >= 64:
		Lib.grabCard(set_name, trans_uncommon, 0, Lib.getPosition(counter).x,Lib.getPosition(counter).y, false)
	else:
		Lib.grabCard(set_name, trans_common, 0, Lib.getPosition(counter).x,Lib.getPosition(counter).y, false)
	counter += 1
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([rare, mythic, rare_oltec, mythic_oltec], [65, 20, 12, 3]), 0, counter, !spg)
	
	if spg:
		Lib.grabCardEasy("spg", Lib.getRarityByWeight([spg_unc, spg_rare, spg_mythic], [60, 30 + (0.5 * spg_luck), 10 + spg_luck]), 0, counter, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	levelLabel.startShowBar()
	
	$"..".drawBackButton();

func createSetPack():
	var spg = (randf_range(0, 100) < Player.spg_luck)
	var counter = 0
	for x in 3:
		Lib.grabCardEasy(set_name, common, 0, counter, false)
		counter += 1
	
	for x in 3:
		Lib.grabCardEasy(set_name, uncommon, 0, counter, false)
		counter += 1
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([trans_common, trans_uncommon, show_unc], [60, 20, 20]), 0, counter, false)
	counter += 1
	
	for x in 2:
		if Lib.doesPass(set_luck, 93):
			Lib.grabCardEasy("rex", rex, 0, counter, false)
		else:
			Lib.grabCardEasy(set_name, Lib.getRarityByWeight([common, uncommon, rare, mythic + Lib.getLuck(set_luck), show_unc, show_rare , show_mythic],[40, 20, 10+ (Lib.getLuck(set_luck)/2), 5 + Lib.getLuck(set_luck), 15, 7 + (Lib.getLuck(set_luck)/2), 3 + Lib.getLuck(set_luck)]), 0, counter, false)
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([common, uncommon, rare, mythic], [60, 30, 7, 3]), 1, counter, false)
	
	Lib.grabCardEasy(set_name, Lib.getRarityByWeight([rare, mythic], [66, 33]), 0, counter, !spg)
	
	if spg:
		Lib.grabCardEasy("spg", Lib.getRarityByWeight([spg_unc, spg_rare, spg_mythic], [60, 30 + (0.5 * spg_luck), 10 + spg_luck]), 0, counter, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	levelLabel.startShowBar()
	
	$"..".drawBackButton();
