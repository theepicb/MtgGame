extends Node2D
var set_name = "rvr"


var common = [3, 4, 5, 7, 10, 11, 12, 13, 17, 18, 21, 22, 25, 26, 27, 29, 37, 38, 41, 42, 45, 46, 47, 48, 49, 53, 56, 58, 60, 61, 64, 65, 66, 67, 68, 69, 72, 73, 74, 77, 79, 82, 85, 88, 91, 92, 94, 96, 99, 102, 103, 104, 105, 106, 108, 109, 115, 119, 121, 122, 124, 127, 128, 130, 131, 132, 135, 136, 139, 140, 141, 143, 145, 147, 151, 154, 155, 156, 157, 158, 166, 169, 172, 177, 181, 182, 184, 185, 186, 192, 200, 203, 204, 209, 219, 225, 226, 236, 238, 239]

var uncommon = [2, 6, 14, 15, 23, 24, 28, 30, 33, 34, 36, 43, 50, 51, 52, 54, 57, 59, 75, 76, 84, 87, 89, 93, 95, 97, 98, 101, 107, 110, 112, 117, 120, 123, 125, 126, 137, 138, 142, 149, 150, 152, 159, 160, 161, 165, 168, 170, 173, 174, 176, 178, 183, 187, 188, 189, 190, 191, 197, 199, 202, 206, 208, 212, 214, 213, 217, 220, 221, 222, 223, 224, 227, 230, 235, 254, 257, 262, 268, 271]

var rare = [8, 9, 19, 31, 32, 39, 44, 55, 62, 63, 70, 78, 83, 86, 90, 100, 111, 114, 116, 118, 133, 134, 144, 148, 162, 163, 167, 171, 175, 180, 194, 195, 196, 201, 207, 210, 211, 215, 218, 228, 229, 231, 233, 234, 237, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 252, 253, 260, 264, 266, 270]

var mythic = [1, 16, 20, 35, 40, 71, 80, 81, 113, 129, 146, 153, 164, 179, 193, 198, 205, 216, 232, 255]

var signet = [250, 251, 256, 258, 259, 261, 263, 265, 267, 269]

var gates = [272, 274, 276, 278, 279, 281, 282, 284]

func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/rvr")
	for x in range(272, 292):
		grabCardExtra(x, 0, 0, 0, false, true)
		await get_tree().create_timer(0.5).timeout
	grabCardExtra(1, 0, 0, 0, true, false)
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
