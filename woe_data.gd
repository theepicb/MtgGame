extends Node2D
var set_name = "woe"
var common = [40,2,3,81,161,121,43,4,122,162,165,5,83,243,6,166,84,8,254,167,125,46,126,88,256,91,92,170,128,130,50,14,246,131,133,134,173,135,174,17,95,54,57,58,18,138,177,59,60,140,141,100,61,62,20,101,63,22,249,24,65,144,103,147,179,181,26,27,182,104,28,250,105,106,149,185,67,29,68,59,186,109,32,71,110,111,189,191,192,153,194,36,37,156,75,196,116,117,77,118,158, 69]
var uncommon = [41,79,201,80,120,44,123,221,45,7,244,9,10,47,85,11,255,12,86,127,245,89,90,226,51,15,52,227,16,171,205,136,94,175,55,229,207,19,139,99,142,209,178,210,64,232,180,183,212,213,236,30,251,237,70,151,187,33,72,214,112,188,152,238,74,23,119,239,253,216,193,217,154,114,155,195,198,159,241,160]
var rare = [1, 34, 164, 124, 222, 223, 224, 225, 168, 13, 48, 49, 203, 169, 129, 132, 172, 93, 228, 53, 247, 137, 56, 96, 208, 98, 97, 231, 233, 234, 143, 102, 146, 25, 257,258,259,260,261,148,235,184,66,150,107,31,108,252,73,113,200,87,204,176,248,35,190,240,39,219]
var mythic = [199, 242, 78, 42, 220, 82, 163, 202, 206, 230, 21, 145, 211, 125, 157, 76, 38, 115, 197, 218,215]

var showcase = [285,291,282,279,277,281,284,283, 286,287,288,289,280,290,278,292,293,294,295,296]

var boarderless = [297,298,299,300,301,302, 303, 304, 305, 306, 307]


var extendedRare = [323, 324, 326, 328, 327, 329, 331, 332, 333, 334, 335, 337, 339, 338, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 351, 352, 353, 355, 356, 357, 358, 359, 361, 362, 364, 365, 367, 368, 369, 370, 371, 372, 373, 374]
var extendedMythic = [325, 330, 336, 350, 354, 360, 363, 366]


func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/woe")

	
	
	
func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	print("started")
	add_child(grab)
	pass


func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing) -> void:
	var pos = Vector2(posX, posY)
	
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass

func createDraftPack () -> void:
	$"../../Achievements".outsideCall("woe_draft")
	var counter = 0
	for x in 9:
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in 3:
		grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	$Wot_data.grabETCardDraft(counter, 0, false)
	counter += 1
	
	if ($"..".getLuck() >= 84):
		grabCard(mythic, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	else:
		grabCard(rare, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.showBar()
	
	print("Inventory ", Player.IDInventory)
	$"..".drawBackButton();

func createCollectorPack ():
	var odds
	var packs
	var counter = 0
	
	for x in 4:
		grabCard(common, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in 3:
		grabCard(uncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	$Wot_data.getWithRarity("uncommon", 0, counter, false)
	counter += 1
	
	$Wot_data.getWithRarity("uncommon", 1, counter, false)
	counter += 1
	
	packs = [rare, mythic]
	odds = [85.7, 14.3]
	
	grabCard(getRarityByWeight(packs, odds), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	packs = [extendedRare, extendedMythic]
	odds = [84, 16]
	
	var foil = getRarityByWeight([0, 1], [50, 50])
	grabCard(getRarityByWeight(packs, odds), foil, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	var rarity = getRarityByWeight(["rare", "mythic", "animeRare", "animeMythic"], [73.3, 10, 6.7, 10])
	$Wot_data.getWithRarity(rarity, 1, counter, false)
	counter += 1
	
	
	rarity = getRarityByWeight([extendedRare, extendedMythic, showcase, boarderless, "rare", "mythic", "animeRare", "animeMythic", "confettiRare", "confettiMythic"], [38.8, 4, 16.2, 7.7, 24.4, 3.3, 1.1, 1.7, 1.1, 1.7])
	if rarity is String:
		if (rarity == "confettiRare" || rarity == "confettiMythic"):
			$Wot_data.getWithRarity(rarity, 3, counter, true)
		else:
			$Wot_data.getWithRarity(rarity, 1, counter, true)
	else:
		grabCard(rarity, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();
	pass

func createSetPack ():
	var odds
	var packs
	var counter = 0
	for x in 3:
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in 3:
		grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	if ($"..".getLuck() >= 95):
		$Wot_data.grabETCardDraft(counter, 0, false)
	else:
		odds = [60, 30, 7, 3]
		packs = [common, uncommon, rare, mythic]
		grabCard(getRarityByWeight(packs, odds), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	
	counter += 1
	
	if ($"..".getLuck() >= 95):
		$Wot_data.grabETCardDraft(counter, 0, false)
	else:
		odds = [60, 30, 7, 3]
		packs = [common, uncommon, rare, mythic]
		grabCard(getRarityByWeight(packs, odds), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	
	counter += 1
	
	if ($"..".getLuck() >= 95):
		$Wot_data.grabETCardDraft(counter, 1, false)
	else:
		odds = [60, 30, 7, 3]
		packs = [common, uncommon, rare, mythic]
		grabCard(getRarityByWeight(packs, odds), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	
	counter += 1
	
	$Wot_data.grabETCardDraft(counter, 0, false)
	
	counter += 1
	
	if ($"..".getLuck() >= 84):
		grabCard(mythic, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	else:
		grabCard(rare, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();
	pass

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]
