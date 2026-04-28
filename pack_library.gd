extends Node2D
var packScreen
func _ready() -> void:
	packScreen = get_node("/root/Main/Pack_Screen")

#returns luck as float with an input for added bonus
func getLuck (inputLuck: float) -> float:
	return randf_range(0, 100) + inputLuck
# returns whether a check passed with an input for luck bonus and a check float
func doesPass(inputLuck: float, check: float) -> bool:
	return randf_range(0, 100) + inputLuck > check

# formula for returning card position at count x
func getPosition(x: int) -> Vector2:
	var pos = Vector2(100 + ((x % 10) * 200), 200 + (290 *(floor(x/ 10))))
	return pos
# takes an array of arrays each with an index in weights and returns a random array
# based on its weights
func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	return arrays[random.rand_weighted(weights)]
# function to construct and start grabbing card, used for basic card types
func grabCard (setName: String, list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var grab = Card_Grabber.new(num, setName, foilEnum, "user://Cards/" + setName, pos, isLast);
	add_child(grab)
	pass
# extended function to contruct and start grabbing cards, allows for specific card grabbing and advanced card types such as
# serial cards
func grabCardExtra (setName: String, number: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing) -> void:
	var pos = Vector2(posX, posY)
	var grab = Card_Grabber.new(number, setName, foilEnum, "user://Cards/" + setName, pos, isLast, isGrabbing);
	add_child(grab)
	pass
# updated basic card grabber with less params
func grabCardEasy(setName: String, list: Array, foilEnum: int, counter: int, isLast: bool):
	var pos = getPosition(counter)
	var num = list.pick_random()
	var grab = Card_Grabber.new(num, setName, foilEnum, "user://Cards/" + setName, pos, isLast);
	add_child(grab);
	pass
# function to ensure a directory exists
func ensure_directory_exists(dir_path: String) -> void:
	var dir = DirAccess.open("user://Cards/")
	if !dir.dir_exists(dir_path):
		var err = dir.make_dir(dir_path)
		if err == OK:
			print("Directory created:", dir_path)
		else:
			print("Failed to create directory:", err)
	else:
		print("Directory already exists:", dir_path)
# function to show a custom image in pack opening
func createCustomImage(im_path: String, amount: int, counter: int):
	var container = VBoxContainer.new()
	container.size = Vector2(300, 160)
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.position = getPosition(counter)
	container.position.x -= 100
	# Create texture rect for sprite
	var texture_rect = TextureRect.new()
	
	# 🔧 Load the image properly
	var texture = load(im_path)
	if texture == null:
		push_error("Failed to load texture at: " + im_path)
	else:
		texture_rect.texture = texture
	
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(300, 160)
	
	var price_label = Label.new()
	price_label.text = str(amount)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	container.add_child(texture_rect)
	container.add_child(price_label)
	
	# Add container to player
	Player.add_child(container)
	Player.cardsToDelete.append(container)
	Player.cardsToShow.append(container)
	container.hide()
	HttpData.Finished.connect(container.show)

# function to grab a pack from its pack id and show it in pack openings
func createCustomPack(im_path: String, amount: int, counter: int, packID: String):
	packScreen.getPack(packID, amount)
	
	var container = VBoxContainer.new()
	container.size = Vector2(310, 160)
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.position = getPosition(counter)
	container.position.y -= 140
	container.position.x += 10
	
	# Create texture rect for sprite
	var texture_rect = TextureRect.new()
	
	# 🔧 Load the image properly
	var texture = load(im_path)
	if texture == null:
		push_error("Failed to load texture at: " + im_path)
	else:
		texture_rect.texture = texture
	
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(350, 215)
	
	var price_label = Label.new()
	price_label.text = str(amount)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	container.add_child(texture_rect)
	container.add_child(price_label)
	
	# Add container to player
	Player.add_child(container)
	Player.cardsToDelete.append(container)
	Player.cardsToShow.append(container)
	container.hide()
	HttpData.Finished.connect(container.show)

# function to grab a random card from an array x times, card cant be final
func forEach(amount: int, setName: String, list: Array, foilEnum: int, counter: int):
	for x in amount:
		grabCardEasy(setName, list, foilEnum, counter, false)
		counter += 1
