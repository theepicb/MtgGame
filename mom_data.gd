extends Node2D
var set_name = "mom"
var serial_max = 500

var draftLuck = 0
var setLuck = 0
var collectorLuck = 0

var serial = {
	338: [],
	339: [],
	340: [],
	341: [],
	342: []
}

var common = [2, 3, 4, 5, 7, 8, 10, 14, 15, 18, 19, 24, 25, 27, 33, 34, 37, 39, 42, 43, 47, 54, 55, 56, 57, 59, 60, 66, 67, 68, 69, 72, 73, 74, 76, 79, 80, 81, 82, 87, 88, 91, 97, 98, 99, 100, 101, 102, 103, 104, 105, 108, 111, 112, 118, 120, 126, 127, 128, 129, 130, 131, 133, 136, 140, 142, 150, 153, 154, 156, 157, 158, 161, 163, 164, 167, 168, 170, 172, 173, 175, 176, 177, 178, 179, 180, 182, 183, 186, 195, 197, 199, 201, 204, 205, 210, 212, 214, 215, 216, 259, 260, 261, 262, 264, 266]
var uncommon = [13, 29, 30, 31, 35, 36, 38, 41, 44, 45, 46, 48, 49, 50, 53, 70, 71, 78, 84, 85, 92, 95, 96, 106, 107, 117, 119, 121, 123, 124, 138, 139, 141, 143, 151, 152, 159, 162, 165, 166, 181, 188, 189, 196, 202, 203, 206, 207, 208, 209, 220, 223, 227, 243, 246, 247, 248, 251, 253, 254]
var rare = [1, 9, 11, 16, 17, 26, 32, 40, 51, 52, 58, 75, 77, 83, 86, 89, 90, 93, 94, 109, 110, 122, 132, 135, 137, 144, 155, 160, 171, 174, 184, 185, 187, 198, 200, 211, 218, 221, 222, 224, 225, 226, 228, 229, 244, 249, 250, 252, 256, 263]
var mythic = [6, 12, 28, 65, 125, 134, 169, 213, 217, 219, 245, 255, 257, 258, 265, 320, 321, 322]

var transf_common = [7, 18, 39, 43, 47, 69, 72, 88, 111, 127, 157, 163, 177, 178, 180]
var transf_uncommon = [29, 36, 38, 44, 49, 53, 78, 92, 96, 106, 117, 119, 139, 143, 151, 188, 189, 209, 223, 248, 253]
var transf_rare = [17, 32, 40, 51, 90, 93, 137, 187, 200, 226]
var transf_mythic = [12, 65, 125, 169, 213]

var invasion_uncommon = [20, 21, 62, 64, 113, 116, 147, 148, 192, 194, 231, 232, 233, 234, 235, 236, 237, 238, 240, 242]
var invasion_rare = [22, 23, 61, 63, 114, 145, 146, 190, 191, 241]
var invasion_mythic = [1, 115, 149, 193, 239]

var jumpstart_ext = [376, 377, 378, 379, 380]
var jumpstart_rare = [323, 326, 331, 334, 337]

var non_basic_land = []

var showcaseRare = [293, 295, 296, 298, 300, 302, 304, 305, 306, 307, 308, 309, 310, 311, 313, 314, 315, 317]
var showcaseMythic = [292, 294, 297, 299, 301, 303, 312, 316, 318, 319]

var extendedRare = [343, 344, 345, 346, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374]
var extendedMythic = [347, 375]

func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/mom")
	for x in range(0,0):
		#grabCardExtra(x, 5, 0, 0, false, true, false)
		await get_tree().create_timer(0.5).timeout
	#grabCardExtra(1, 0, 0, 0, true, true, false)
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	print(("common: "),Player.common)
	print(("uncommon: "),Player.uncommon)
	print(("rare: "),Player.rare)
	print(("mythic: "),Player.mythic)
	print("signet: ", Player.signet)

func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing, serialNum) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing, true, serialNum, serial_max);
	print("started")
	add_child(grab)
	pass

func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	print("started")
	add_child(grab)
	pass

func createDraftPack():
	var luck = draftLuck + Player.luck
	var counter = 0;
	var foil = false
	var commonAm = 9
	if randf_range(0, 100) + luck >= 67:
		foil = true
		commonAm = 8
	for x in range(commonAm):
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in range(2):
		grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	grabCard($"..".getRarityByWeight([transf_common, transf_uncommon, transf_rare, transf_mythic], [60, 25, 10 + luck, 5 + luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([invasion_uncommon, invasion_rare, invasion_mythic], [65, 30 + luck, 5 + luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	$Mul_data.grabNormal(luck, true, 0, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([rare, mythic],[84, 16]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, !foil)
	
	if foil:
		grabCard($"..".getRarityByWeight([common, uncommon, rare, mythic],[60, 25, 10 + luck, 5 + luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();

func createSetPack ():
	var counter = 1
	var luck = Player.luck + setLuck
	for x in range(2):
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in range(2):
		grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	grabCard($"..".getRarityByWeight([transf_common, transf_uncommon], [60, 25]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard(invasion_uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	for x in range(2):
		if randf_range(0,100) > 60:
			$Mul_data.grabNormal(luck, true, 0, false)
		else:
			grabCard($"..".getRarityByWeight([common, uncommon, rare, mythic, jumpstart_rare], [65, 30, 10 + luck, 5 + luck, 7]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	if randf_range(0,100) > 60:
		if randf_range(0, 100) + luck > 80:
			$Mul_data.grabetched(luck, false, counter)
		else:
			$Mul_data.grabNormal(luck, true, 1, false)
	else:
		grabCard($"..".getRarityByWeight([common, uncommon, rare, mythic], [65, 30, 10 + luck, 5 + luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	$Mul_data.grabNormal(luck, true, 0, counter)
	counter += 1
	
	grabCard($"..".getRarityByWeight([rare, mythic], [80, 20 + luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();

func createCollectorPack ():
	var counter = 1
	var luck = Player.luck + collectorLuck
	for x in range(5):
		grabCard(common, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	for x in range(2):
		grabCard(uncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	grabCard($Mul_data.uncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([rare, mythic], [80, 20 + luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	
	if randf_range(0, 100) >= 80:
		grabCard(jumpstart_ext, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		$Moc_data.getExtended(counter, luck, 0, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([showcaseRare, showcaseMythic, extendedRare, extendedMythic], [40, 10 + luck, 40, 10 + luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	if randf_range(0, 100) >= 99.6 - (float(luck) / 2):
		if !$Mul_data.grabUncommonSerial(counter, false):
			$Mul_data.grabUncommEtchOrSurge(counter, luck, false)
			pass
	else :
		$Mul_data.grabUncommEtchOrSurge(counter, luck, false)
	counter += 1
	
	if randf_range(0, 100) >= 99.8 - (float(luck) / 2):
		if !grabSerial(counter, false):
			grabCard($"..".getRarityByWeight([extendedRare, extendedMythic, showcaseRare, showcaseMythic], [40, 10, 40, 10]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard($"..".getRarityByWeight([extendedRare, extendedMythic, showcaseRare, showcaseMythic], [40, 10, 40, 10]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	
	if randf_range(0, 100) >= 99.6 - (float(luck) / 2):
		if !$Mul_data.grabRareSerial(counter, true):
			if randf_range(0, 100) >= 60 + luck:
				$Mul_data.grabSurgeRare(luck, true, counter)
			else:
				$Mul_data.grabEtchedRare(luck, true, counter)
			pass
	else :
		if randf_range(0, 100) >= 60 + luck:
			$Mul_data.grabSurgeRare(luck, true, counter)
		else:
			$Mul_data.grabEtchedRare(luck, true, counter)
	counter += 1
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();

func returnDictionary () -> Dictionary:
	var momDictionary = {
		"setLuck": setLuck,
		"draftLuck": draftLuck,
		"collectorLuck": collectorLuck,
		"mulUncomSer": $Mul_data.serialUncommon,
		"mulRareSer": $Mul_data.serialRareMythic,
		"praetorSerial": serial
	}
	return momDictionary
	
func setDictionary (dict: Dictionary):
	setLuck = dict.get("setLuck", 0)
	draftLuck = dict.get("draftLuck", 0)
	collectorLuck = dict.get("collectorLuck", 0)
	$Mul_data.serialUncommon = dict.get("mulUncomSer", $Mul_data.serialUncommon)
	$Mul_data.serialRareMythic = dict.get("mulRareSer", $Mul_data.serialRareMythic)
	serial = dict.get("praetorSerial", serial)

func grabSerial (counter, isLast) -> bool:
	var number
	var key
	key = serial.keys().pick_random()
	number = $"..".chooseSerialNumber(serial_max, serial[key])
	if !number == -1:
		grabCardExtra(key, 5, $"..".getPosition(counter).x, $"..".getPosition(counter).y, isLast, false, number)
		return true
	return false
