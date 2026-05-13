extends Node2D
var path = "user://Cards/";

func _ready() -> void:
	ensure_directory_exists(path)
	pass
	
func ensure_directory_exists(dir_path: String) -> void:
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(dir_path):
		var err = dir.make_dir(dir_path)
		if err == OK:
			print("Directory created:", dir_path)
		else:
			print("Failed to create directory:", err)
	else:
		print("Directory already exists:", dir_path)
		
func getPosition(x) -> Vector2:
	var pos = Vector2(100 + ((x % 10) * 200), 200 + (290 *(floor(x/ 10))))
	return pos

func getLuck(pack_luck: float = 0) -> int:
	var num = randi_range(0, 100)
	num = num + (Player.luck + pack_luck)
	return num
	
func drawBackButton ():
	print("Cards to show:", Player.cardsToShow)
	$"../CanvasLayer/Back_Button".draw()

func chooseSerialNumber (max_num: int, array: Array) -> int:
	var number = randi_range(0, max_num)
	if !array.has(number):
		return number
	else:
		var number_stamp = number
		while number != 0:
			number -= 1
			if !array.has(number):
				return number
		number = number_stamp
		while number != max_num:
			number += 1
			if !array.has(number):
				return number
	return -1

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]

func returnDictionary() -> Dictionary:
	var dict = {
		"woe": $Woe_data.returnDictionary(),
		"rvr": $Rvr_data.returnDictionary(),
		"mom": $Mom_data.returnDictionary(),
		"mat": $Mat_data.returnDictionary(),
		"lc1": $Lci_data.returnDictionary(),
	}
	return dict

func setDictionary(dict: Dictionary):
	$Woe_data.setDictionary(dict.get("woe", {}))
	$Rvr_data.setDictionary(dict.get("rvr", {}))
	$Mom_data.setDictionary(dict.get("mom", {}))
	$Mat_data.setDictionary(dict.get("mat", {}))
	$Lci_data.setDictionary(dict.get("lci", {}))
	
