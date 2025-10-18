extends Node2D

var set_name = "mom"
var serial_max = 500

func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/mom")
	for x in range(338, 339):
		#grabCardExtra(x, 5, 0, 0, false, true, 69)
		await get_tree().create_timer(0.5).timeout
	#grabCardExtra(1, 0, 0, 0, true, false, 0)
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
