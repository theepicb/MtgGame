extends Node2D
var set_name = "mul"

var uncommon = [2, 5, 10, 12, 18, 19, 24, 25, 26, 28, 31, 37, 40, 43, 46, 55, 56, 57, 58, 59]
var rare = [1, 6, 7, 8, 9, 13, 14, 15, 20, 22, 27, 30, 32, 34, 36, 39, 42, 44, 45, 47, 48, 50, 51, 52, 54, 60, 61, 62, 64]
var mythic = [3, 4, 11, 16, 17, 21, 23, 29, 33, 35, 38, 41, 49, 53, 63]


var serial_max = 500

func _ready() -> void:
	$"../..".ensure_directory_exists("user://Cards/mul")
	for x in range(0, 0):
		grabCardExtra(x, 5, 0, 0, false, true, false)
		await get_tree().create_timer(0.5).timeout
	grabCardExtra(1, 0, 0, 0, true, true, false)
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
	

func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing, serialNum) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing, false, serialNum, serial_max);
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
