extends Node2D
var set_name = "mul"

var uncommon = [2, 5, 10, 12, 18, 19, 24, 25, 26, 28, 31, 37, 40, 43, 46, 55, 56, 57, 58, 59]
var rare = [1, 6, 7, 8, 9, 13, 14, 15, 20, 22, 27, 30, 32, 34, 36, 39, 42, 44, 45, 47, 48, 50, 51, 52, 54, 60, 61, 62, 64]
var mythic = [3, 4, 11, 16, 17, 21, 23, 29, 33, 35, 38, 41, 49, 53, 63]

var etched_uncommon = [67, 70, 75, 77, 83, 84, 89, 90, 91, 93, 96, 102, 105, 108, 111, 120, 121, 122, 123, 124]
var etched_rare = [66, 71, 72, 73, 74, 78, 79, 80, 85, 87, 92, 95, 97, 99, 101, 104, 107, 109, 110, 112, 113, 115, 116, 117, 119, 125, 126, 127, 129, 130]
var etched_mythic = [68, 69, 76, 81, 82, 86, 88, 94, 98, 100, 103, 106, 114, 118, 128]

var surge_uncommon = [132, 135, 140, 142, 148, 149, 154, 155, 156, 158, 161, 167, 170, 173, 176, 185, 186, 187, 188, 189]
var surge_rare =[131, 136, 137, 138, 139, 143, 144, 145, 150, 152, 157, 160, 162, 164, 166, 169, 172, 174, 175, 177, 178, 180, 181, 182, 184, 190, 191, 192, 194] 
var surge_mythic = [133, 134, 141, 146, 147, 151, 153, 159, 163, 168, 171, 179, 183, 193]

var serial_max = 500

var serialUncommon = {
	2: [],
	5: [],
	10: [],
	12: [],
	18: [],
	19: [],
	24: [],
	25: [],
	26: [],
	28: [],
	31: [],
	37: [],
	40: [],
	43: [],
	46: [],
	55: [],
	56: [],
	57: [],
	58: [],
	59: []
}

var serialRareMythic = {
	1: [],
	3: [],
	4: [],
	6: [],
	7: [],
	8: [],
	9: [],
	11: [],
	13: [],
	14: [],
	15: [],
	16: [],
	17: [],
	20: [],
	21: [],
	22: [],
	23: [],
	27: [],
	29: [],
	30: [],
	32: [],
	33: [],
	35: [],
	36: [],
	38: [],
	39: [],
	41: [],
	42: [],
	44: [],
	45: [],
	47: [],
	48: [],
	49: [],
	50: [],
	51: [],
	52: [],
	53: [],
	54: [],
	60: [],
	61: [],
	62: [],
	63: [],
	64: [],
}

func _ready() -> void:
	$"../..".ensure_directory_exists("user://Cards/mul")
	for x in range(0, 0):
		grabCardExtra(x, 1, 0, 0, false, true, false)
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

func grabNormal(luck: float, isLast: bool, isFoil: int, counter: int):
	grabCard($"../..".getRarityByWeight([uncommon, rare, mythic], [65, 20 + luck, 5 + luck]),0, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)

func grabetched(luck: float, isLast: bool,  counter: int):
	grabCard($"../..".getRarityByWeight([etched_uncommon, etched_rare, etched_mythic], [65, 20 + luck, 5 + luck]),2, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)

func grabEtchedRare(luck: float, isLast: bool, counter: int):
	grabCard($"../..".getRarityByWeight([etched_rare, etched_mythic], [80, 20 + luck]),2, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)

func grabSurgeRare(luck: float, isLast: bool, counter: int):
	grabCard($"../..".getRarityByWeight([surge_rare, surge_mythic], [80, 20 + luck]), 1, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)

func grabUncommEtchOrSurge(counter, luck, isLast):
	if randi_range(0, 100) + luck >= 60:
		grabCard(surge_uncommon, 1, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)
	else:
		grabCard(etched_uncommon, 2, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)

func grabUncommonSerial (counter, isLast) -> bool:
	var number
	var key
	key = serialUncommon.keys().pick_random()
	number = $"../..".chooseSerialNumber(serial_max, serialUncommon[key])
	if !number == -1:
		grabCardExtra(key, 5, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast, false, number)
		return true
	return false

func grabRareSerial (counter, isLast) -> bool:
	var number
	var key
	key = serialRareMythic.keys().pick_random()
	number = $"../..".chooseSerialNumber(serial_max, serialRareMythic[key])
	if !number == -1:
		grabCardExtra(key, 5, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast, false, number)
		return true
	return false

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
