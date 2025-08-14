extends Node2D
var set_name = "wot"

var uncommon = [15,17,28,41,53,3,5,54,20,44,6,8,47,61,26,36,63,37]
var rare = [39,14,1,16,2,42,18,19,43,55,21,7,56,23,45,10,30,46,57,32,33,11,34,59,60,12,35,49,62,38]
var mythic = [52,29,4,22,9,31,24,58,48,25,13,50]

var animeRare = [76,68,65,82,75]
var animeMythic = [72,77,80,81,73,64,69,66,74,70,83,78,71,67,79]


func _ready() -> void:
	$"../..".ensure_directory_exists("user://Cards/wot")
	

func grabETCardDraft (count: int, foil: int, isLast: bool):
	grabCard(getRarityByWeight([uncommon, rare, mythic, animeRare, animeMythic], [60, 30, 7.2, 1.1, 1.7]), foil, $"../..".getPosition(count).x, $"../..".getPosition(count).y, isLast)

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
	
