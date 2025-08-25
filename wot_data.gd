extends Node2D
var set_name = "wot"
@onready var woe = get_parent()
var uncommon = [15,17,28,41,53,3,5,54,20,44,6,8,47,61,26,36,63,37]
var rare = [39,14,1,16,2,42,18,19,43,55,21,7,56,23,45,10,30,46,57,32,33,11,34,59,60,12,35,49,62,38]
var mythic = [52,29,4,22,9,31,24,58,48,25,13,50,27,40,51]

var animeRare = [76,68,65,82,75]
var animeMythic = [72,77,80,81,73,64,69,66,74,70,83,78,71,67,79]

var confettiRare = [85, 88, 95, 96, 102]
var confettiMythic = [84, 86, 87, 89, 90, 91, 93, 92, 94, 97, 98, 99, 100, 101, 103]


func _ready() -> void:
	$"../..".ensure_directory_exists("user://Cards/wot")
	for x in range(25, 26):
		grabCardExtra(x, 0, 0, 0, false, true)
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
	

func grabETCardDraft (count: int, foil: int, isLast: bool):
	grabCard(getRarityByWeight([uncommon, rare, mythic, animeRare, animeMythic], [60, 30, 7.2 * woe.draft_luck, 1.1, 1.7 * woe.draft_luck]), foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)

func getWithRarity(rarity: String, foil: int, count: int, isLast: bool):
	match rarity:
		"uncommon": grabCard(uncommon, foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"rare": grabCard(rare, foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"mythic": grabCard(mythic, foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"animeRare": grabCard(animeRare, foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"animeMythic": grabCard(animeRare, foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"confettiRare": grabCard(confettiRare, 3, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)
		"confettiMythic": grabCard(confettiMythic, 3, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)

func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	print("started")
	add_child(grab)
	pass

func getRarity (mythicc: Array, rarec: Array, uncommonc: Array) -> Array:
	if ($"../..".getLuck() > 84):
		if ($"../..".getLuck() > 84):
			return mythicc
		else:
			return rarec
	else:
		return uncommonc

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]

func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing) -> void:
	var pos = Vector2(posX, posY)
	
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass
