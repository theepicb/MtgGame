extends Node2D
var set_name = "moc"
var serial_max = 0

var setRare = [72, 73, 74, 76, 77, 78]
var setMythic = [75, 79]
var rare
var mythic
var extendedRare = [80, 81, 82, 84, 85, 86, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132]
var extendedMythic = [83, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97]


func _ready() -> void:
	$"../..".ensure_directory_exists("user://Cards/moc")
	for x in range(0, 0):
		grabCardExtra(x, 0, 0, 0, false, true, false)
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

func getExtended (counter, luck, foil, isLast):
	grabCard($"../..".getRarityByWeight([extendedRare, extendedMythic], [80, 20 + luck]),foil, $"../..".getPosition(counter).x, $"../..".getPosition(counter).y, isLast)
