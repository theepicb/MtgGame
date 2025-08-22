extends Node2D
var set_name = "rvr"


var common = []
var uncommon = []
var rare = []
var mythic = []

func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/rvr")
	for x in range(1057, 1067):
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
