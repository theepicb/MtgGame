extends Node2D
var set_name = "mat"

var uncommon = [1, 3, 7, 8, 12, 13, 14, 17, 19, 20, 25, 27, 28, 30, 31]
var rare = [2, 4, 5, 9, 10, 11, 15, 16, 18, 21, 23, 24, 29, 32, 33, 34, 37, 39, 40, 42, 43, 44, 47, 50]
var mythic = [22, 26, 35, 36, 38, 41, 45, 46, 48, 49]
var specialUncommon = [51, 53, 57, 58, 62, 63, 64, 67, 69, 70, 75, 77, 78, 79, 80, 81]
var specialRare = [52, 54, 55, 56, 59, 60, 61, 65, 66, 68, 71, 73, 74, 82, 83, 84, 87, 89, 90, 92, 93, 94, 97, 100]
var specialMythic = [72, 76, 85, 86, 88, 91, 95, 96, 98, 99]
var etchedUncommon = [101, 103, 107, 108, 112, 113, 114, 117, 119, 120, 125, 127, 128, 130, 131]
var etchedRare = [102, 104, 105, 106, 109, 110, 111, 115, 116, 118, 121, 123, 124, 129, 132, 133, 134, 137, 139, 140, 142, 143, 144, 147, 150]
var etchedMythic  = [122, 126, 135, 136, 138, 141, 145, 146, 148, 149]
var surgeRare = [151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 163, 164, 166, 167]



func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var path = $"..".ensure_directory_exists("user://Cards/" + set_name)
	var num = list.pick_random();
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	add_child(grab)
	pass
func _ready() -> void:
	#grabCard(uncommon, 1, Vector2(0, 0))
	pass

func createDraftPack () -> void:
	for x in 18:
		if x != 17:
			grabCard(uncommon, 1, 100 + ((x % 9) * 200), 200 + (290 *(floor(x/ 9))), false)
		else:
			grabCard(uncommon, 0, 100 + ((x % 9) * 200), 200 + (290 *(floor(x/ 9))), true)
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	for y in Player.cardsToShow:
		y.showCard(y.pos.x, y.pos.y)
		y.displayPrice();
		pass
