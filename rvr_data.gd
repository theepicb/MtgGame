extends Node2D
var set_name = "rvr"

var serial_max = 500

var draft_luck = 1
var collector_luck = 1

var serial = {
	302: [],
	303: [],
	306: [],
	308: [],
	309: [],
	312: [],
	313: [],
	319: [],
	320: [],
	322: [],
	323: [],
	326: [],
	327: [],
	328: [],
	331: [],
	333: [],
	334: [],
	335: [],
	337: [],
	339: [],
	342: [],
	344: [],
	345: [],
	348: [],
	349: [],
	350: [],
	353: [],
	356: [],
	357: [],
	360: [],
	363: [],
	365: [],
	369: [],
	370: [],
	371: [],
	373: [],
	375: [],
	376: [],
	377: [],
	379: [],
	381: [],
	383: [],
	384: [],
	385: [],
	386: [],
	387: [],
	388: [],
	389: [],
	390: [],
	391: [],
	392: [],
	393: [],
	394: [],
	395: [],
	397: [],
	399: [],
	401: [],
	404: [],
	407: [],
	409: [],
	412: [],
	413: [],
	414: [],
	415: []
}

var common = [3, 4, 5, 7, 10, 11, 12, 13, 17, 18, 21, 22, 25, 26, 27, 29, 37, 38, 41, 42, 45, 46, 47, 48, 49, 53, 56, 58, 60, 61, 64, 65, 66, 67, 68, 69, 72, 73, 74, 77, 79, 82, 85, 88, 91, 92, 94, 96, 99, 102, 103, 104, 105, 106, 108, 109, 115, 119, 121, 122, 124, 127, 128, 130, 131, 132, 135, 136, 139, 140, 141, 143, 145, 147, 151, 154, 155, 156, 157, 158, 166, 169, 172, 177, 181, 182, 184, 185, 186, 192, 200, 203, 204, 209, 219, 225, 226, 236, 238, 239]

var uncommon = [2, 6, 14, 15, 23, 24, 28, 30, 33, 34, 36, 43, 50, 51, 52, 54, 57, 59, 75, 76, 84, 87, 89, 93, 95, 97, 98, 101, 107, 110, 112, 117, 120, 123, 125, 126, 137, 138, 142, 149, 150, 152, 159, 160, 161, 165, 168, 170, 173, 174, 176, 178, 183, 187, 188, 189, 190, 191, 197, 199, 202, 206, 208, 212, 214, 213, 217, 220, 221, 222, 223, 224, 227, 230, 235, 254, 257, 262, 268, 271]

var rare = [8, 9, 19, 31, 32, 39, 44, 55, 62, 63, 70, 78, 83, 86, 90, 100, 111, 114, 116, 118, 133, 134, 144, 148, 162, 163, 167, 171, 175, 180, 194, 195, 196, 201, 207, 210, 211, 215, 218, 228, 229, 231, 233, 234, 237, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 252, 260, 264, 266, 270]

var mythic = [1, 16, 20, 35, 40, 71, 80, 81, 113, 129, 146, 153, 164, 179, 193, 198, 205, 216, 232, 255]

var signet = [250, 251, 256, 258, 259, 261, 263, 265, 267, 269]

var gates = [272, 274, 276, 278, 279, 281, 282, 284]

var shocks = [253, 275, 277, 280, 273, 283, 289, 290, 285, 288]

var boarderless_shocks = [292, 293, 294, 295, 296, 297, 298, 299, 300, 301]

var retro_common = [307, 311, 314, 310, 316, 321, 324, 343, 336, 340, 358, 361, 354, 367, 460]

var retro_uncommon = [305, 304, 315, 325, 317, 330, 332, 318, 329, 346, 347, 338, 341, 352, 355, 359, 351, 364, 368, 362, 372, 366, 378, 380, 382, 374, 447]

var retro_rare = [302, 303, 301, 312, 308, 322, 319, 320, 331, 326, 328, 344, 333, 335, 345, 337, 339, 348, 360, 363, 350, 365, 357, 375, 370, 379, 371, 376, 377, 384, 385, 387, 389, 381, 383, 386,  388, 394, 393, 392, ]

var retro_mythic = [306, 309, 313, 323, 327, 334, 342, 349, 353, 356, 369, 373, 391]

var retro_shocks = [390, 397, 395, 399, 401, 404, 407, 409, 412, 414, 413]

var retro_gates = [398, 400, 396, 402, 403, 405, 406, 410, 408, 411]

var boarderless_rare = [417, 420, 421, 422, 423, 425, 426, 427, 428, 430, 432, 434, 438, 439, 440, 441, 442]

var boarderless_mythic = [416, 418, 419, 424, 429, 431, 433, 435, 436, 437, 443, ]

var boarderless_planes = [444, 445]

var col_common = [460]

var col_uncommon = [447, 448, 452, 453, 454, 456, 457, 458, 462]

var col_rares = [446, 450, 451, 458, 462, 450, 455, 461, 463, 464]

var col_mythics = [449, 459, 465]



func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/rvr")
	for x in range(452, 466):
		#grabCardExtra(x, 5, 0, 0, false, true, 69)
		await get_tree().create_timer(0.5).timeout
	grabCardExtra(1, 0, 0, 0, true, false, 69)
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	print(("common: "),Player.common)
	print(("uncommon: "),Player.uncommon)
	print(("rare: "),Player.rare)
	print(("mythic: "),Player.mythic)
	print("signet: ", Player.signet)
	
	
func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	print("started")
	add_child(grab)
	pass

func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing, serialNum) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new("415z", set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing, true, serialNum, serial_max);
	print("started")
	add_child(grab)
	pass

func createDraftPack ():
	$"../../Achievements".outsideCall("rvr_draft")
	var total_luck = Player.luck * draft_luck
	var counter = 0
	var foil = false
	var commons = 8
	var isRetroRare = false
	if (randi_range(0, 100) * total_luck > 66):
		foil = true
		commons = 7
	if ((randi_range(0, 100) * total_luck > 84)):
		isRetroRare = true
	
	
	for x in commons:
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	if (randi_range(0, 100) * total_luck > 66):
		var rarity = $"..".getRarityByWeight([common, uncommon, rare, mythic], [60, 25, 10 * total_luck, 5 * total_luck])
		grabCard(rarity, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	else:
		grabCard(common, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	if !isRetroRare:
		grabCard($"..".getRarityByWeight([retro_common, retro_uncommon],[66, 33 * total_luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard($"..".getRarityByWeight([common, uncommon],[66, 33 * total_luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	for x in 3:
		grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	grabCard($"..".getRarityByWeight([gates, signet, shocks],[60, 31, 9 * total_luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	if isRetroRare:
		grabCard($"..".getRarityByWeight([retro_rare, retro_mythic, retro_shocks],[86, 16 * total_luck, 5 * total_luck]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, !foil)
	else:
		grabCard($"..".getRarityByWeight([rare, mythic],[84, 16]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, !foil)
	counter += 1
	if foil:
		grabCard($"..".getRarityByWeight([common, uncommon, rare, mythic, retro_common, retro_uncommon, retro_rare, shocks],[62, 20, 13 * total_luck, 7 * total_luck, 62, 20, 13 * total_luck, 7 * total_luck, 7 * total_luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();
	pass

func createCollectorPack ():
	var isSerial = false
	var total_luck = collector_luck * Player.luck
	$"../../Achievements".outsideCall("rvr_col")
	var counter = 0
	for x in 4:
		grabCard(common, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	for x in 3:
		grabCard(uncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	grabCard($"..".getRarityByWeight([gates, signet, shocks],[60, 31, 9 * total_luck]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	for x in 2:
		grabCard($"..".getRarityByWeight([retro_common, retro_uncommon, col_common, col_uncommon],[55.81, 30.23, 2.33, 11.63]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
		counter += 1
	
	grabCard($"..".getRarityByWeight([retro_common, retro_uncommon, col_common, col_uncommon],[55.81, 30.23, 2.33, 11.63]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([rare, mythic],[88, 12]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard($"..".getRarityByWeight([boarderless_rare, boarderless_planes, boarderless_mythic, boarderless_shocks],[52, 5.5, 15, 27.5]), 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	var number
	var key
	if randf_range(0, 100) + (total_luck) > 99:
		key = serial.keys().pick_random()
		number = $"..".chooseSerialNumber(500, serial[key])
		if !number == -1:
			isSerial = true
			serial[key].append(number)
	
	if isSerial:
		grabCardExtra(int(key), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true, false, number)
	else:
		grabCard($"..".getRarityByWeight([retro_rare, retro_mythic, col_rares, col_mythics, boarderless_rare, boarderless_planes, boarderless_mythic, boarderless_shocks],[55.2,5.3,10.6,2.1,13.4,1.4,4,7]), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();
	pass

func returnDictionary ():
	var dict = {
	"draft_luck": draft_luck,
	"collector_luck": collector_luck,
	"serial": serial
	}
	return dict

func setDictionary (dict: Dictionary):
	draft_luck = dict.get("draft_luck", 1)
	collector_luck = dict.get("collector_luck", 1)
	serial = dict.get("serial", serial)
