extends Node2D
var set_name = "mat"

var uncommon = [1, ]
var rare = [2, 4, 5, 9, 10, 11, 15, 16, 18, 21, 23, 24, 29, 32, 33, 34, 37, 39, 40, 42, 43, 44, 47, 50]
var mythic = [22, 26, 35, 36, 38, 41, 45, 46, 48, 49]
var specialUncommon = [51, 53, 57, 58, 62, 63, 64, 67, 69, 70, 75, 77, 78, 79, 80, 81]
var specialRare = [52, 54, 55, 56, 59, 60, 61, 65, 66, 68, 71, 73, 74, 82, 83, 84, 87, 89, 90, 92, 93, 94, 97, 100]
var specialMythic = [72, 76, 85, 86, 88, 91, 95, 96, 98, 99]
var etchedUncommon = [101, 103, 107, 108, 112, 113, 114, 117, 119, 120, 125, 127, 128, 130, 131]
var etchedRare = [102, 104, 105, 106, 109, 110, 111, 115, 116, 118, 121, 123, 124, 129, 132, 133, 134, 137, 139, 140, 142, 143, 144, 147, 150]
var etchedMythic  = [122, 126, 135, 136, 138, 141, 145, 146, 148, 149]
var extendedRare = [151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 163, 164, 166, 167]
var extendedMythic = [162, 165, 170, 171, 173, 176, 180, 181, 183, 184]
var halouncommon = [186]


func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	add_child(grab)
	pass
func _ready() -> void:
	#grabCard(halouncommon, 1, 0, 0, true)
	pass

func createDraftPack () -> void:
	var counter = 0
	for x in 2:
			grabCard(uncommon, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
			counter += 1
		
	if ($"..".getLuck() > 84):
		grabCard(mythic, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard(rare, 0, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard(getRarity(mythic, rare, uncommon), 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter+= 1
	
	var foil = 0;
	if ($"..".getLuck() > 84):
		foil = 1; 
	
	grabCard(getRarity(specialMythic, specialRare, specialUncommon), foil, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	for y in Player.cardsToShow:
		y.showCard(y.pos.x, y.pos.y, 1)
		y.displayPrice();
		pass
	print("Inventory ", Player.IDInventory)
	$"..".drawBackButton();

func createCollectorPack ():
	var counter = 0;
	
	grabCard(specialUncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	grabCard(etchedUncommon, 2, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	if $"..".getLuck() >= 84:
		grabCard(mythic, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard(rare, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	if $"..".getLuck() >= 84:
		grabCard(mythic, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard(rare, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	var foil
	if $"..".getLuck() >= 84:
		foil = 1
	else: foil = 0;
	
	if $"..".getLuck() >= 84:
		grabCard(extendedMythic, foil, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard(extendedRare, foil, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	if $"..".getLuck() >= 84:
		grabCard(etchedMythic, 2, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	else:
		grabCard(etchedRare, 2, $"..".getPosition(counter).x, $"..".getPosition(counter).y, false)
	counter += 1
	
	var halo: bool
	if $"..".getLuck() >= 0:
		halo = true
	else: halo = false
	
	if halo:
		grabCard(halouncommon, 1, $"..".getPosition(counter).x, $"..".getPosition(counter).y, true)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	for y in Player.cardsToShow:
		y.showCard(y.pos.x, y.pos.y, 1)
		y.displayPrice();
		pass
	$"..".drawBackButton();
	pass

func getRarity (mythicc: Array, rarec: Array, uncommonc: Array) -> Array:
	if ($"..".getLuck() > 84):
		if ($"..".getLuck() > 84):
			return mythicc
		else:
			return rarec
	else:
		return uncommonc
