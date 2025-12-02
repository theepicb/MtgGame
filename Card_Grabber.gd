extends Node
class_name Card_Grabber

var cardID: String
var number: int
@warning_ignore("shadowed_variable_base_class")
var set_name: String
var isFoil: int
var card_value: float;
var save_path: String;
var ID = ""
var price: float
var pos: Vector2
var isSerial: bool

var httpRequest1: HTTPRequest;
var httpRequest2: HTTPRequest;

var imageURL: String;

var isLast: bool
var new_card: Card

var grabbingRarity: bool
var rarity: String

var extraLetter: String
var serialNum: int
var serialMaxNum

func _init(number, set_name: String, foilEnum: int, save_path: String, position: Vector2, isLast: bool, gettingRarity: bool = false, isSerial:bool = false, serialNum: int = 0, serialMaxNum:int = 0) -> void:
	# defining variables
	self.number = number;
	self.set_name = set_name;
	self.isFoil = foilEnum;
	self.save_path = save_path;
	self.pos = position
	self.isLast = isLast
	self.grabbingRarity = gettingRarity
	self.isSerial = isSerial
	extraLetter = ""
	if isSerial:
		extraLetter = "z"
		self.serialNum = serialNum
		self.serialMaxNum = serialMaxNum
	self.cardID = createID()
	# create new instance of card then adds it as a child of the player
	#print(self.isFoil)
	
	# cards currently being shown as pack
	
	#card inventory
	
	generateCard();
	#print("started card generation", save_path)
	pass

func generateCard () -> void:
	if (!Player.IDInventory.has(self.cardID) || self.isSerial || self.grabbingRarity):
		self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number) + ".png"), pos)
		Player.add_child(new_card)
		if !grabbingRarity:
			Player.IDInventory.push_back(new_card.ID);
			Player.cardInventory.push_back(new_card)
			Player.cardsToShow.push_back(new_card);
		startPing();
		pass
	else:
		print("duplicate found")
		print("player children: " + str(Player.get_children()))
		for child in Player.get_children():
			print("self:", self.ID)
			if child.is_class("Sprite2D"):
				print(self.ID + " " + child.ID)
				if "ID" in child and child.ID == self.ID:
					child.amount += 1
					print("amount added new amount:", child.amount)
					self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number) + extraLetter + ".png"), pos)
					Player.add_child(new_card)
					Player.cardsToShow.push_back(new_card);
					Player.cardsToDelete.push_back(new_card)
					finished();
					return

		self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number)+ extraLetter + ".png"), pos)
		Player.add_child(new_card)
		Player.cardsToShow.push_back(new_card);
		Player.cardsToDelete.push_back(new_card)
		startPing();
		pass
	pass

func firstPing(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var _ID = cardID
	if response_code != 200:
		push_error("API request failed number: %s with code %d" % [str(number), response_code])
		finished()
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if typeof(json) != TYPE_DICTIONARY:
		push_error("Invalid JSON response")
		return

	# Directly the card object
	process_card_json(json)


func process_card_json(json: Dictionary) -> void:
	if grabbingRarity:
		var type = json.get("type_line")
		print(type)
		var value = json.get("name")
		if typeof(value) == TYPE_STRING and "Land" in value:
			Player.signet.append(number)
		if type != ("Land") && !type.contains("Battle"):
			print("transform found")
		#else:
			match json.get("rarity"):
				"common": Player.common.append(number)
				"uncommon": Player.uncommon.append(number)
				"rare": Player.rare.append(number)
				"mythic": Player.mythic.append(number)
	
	var cardname = json.get("name", "Unknown Card")
	new_card.setName(cardname)

	var prices = json.get("prices", {})
	var specialPrices = ["mom338z", "mom339z", "mom340z", "mom341z", "mom342z"]
	print("card substring ", cardID.substr(0, 7))
	if specialPrices.has(cardID.substr(0, 7)):
		match cardID.substr(0, 7):
			"mom338z": card_value = 100
			"mom339z": card_value = 77
			"mom340z": card_value = 85
			"mom341z": card_value = 44
			"mom342z": card_value = 41 
	else:
		match isFoil:
			0: card_value = get_safe_float(prices, "usd", ID)
			1: card_value = get_safe_float(prices, "usd_foil", ID)
			2: card_value = get_safe_float(prices, "usd_etched", ID)
			3, 4: card_value = get_safe_float(prices, "usd_foil", ID)
			5: card_value = get_safe_float(prices, "usd_foil", ID)
			_: card_value = 0.0

	var image_uris = json.get("image_uris", {})
	if image_uris.is_empty() and json.has("card_faces"):
		var card_faces = json["card_faces"]
		if card_faces.size() > 0:
			var front_face = card_faces[0]
			if front_face.has("image_uris"):
				image_uris = front_face["image_uris"]

	if not image_uris.has("png"):
		push_error("No PNG image available for this card")
		return

	imageURL = image_uris["png"]
	new_card.setPrice(card_value)

	if FileAccess.file_exists(ProjectSettings.globalize_path(save_path + "/" + str(number) + extraLetter + ".png")):
		print("image exists!")
		new_card.call_deferred("loadImage")
		finished()
	else:
		httpRequest2 = HTTPRequest.new()
		HttpData.add_child(httpRequest2)
		httpRequest2.request_completed.connect(secondPing)
		httpRequest2.request(image_uris["png"])

func secondPing (result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var _ID = cardID
	if response_code != 200:
		push_error("Image download failed with code: %d" % response_code)
		return
	
	var image = Image.new()
	if image.load_png_from_buffer(body) != OK:
		push_error("Failed to load image from buffer")
		return
	var new_size = Vector2(186.25, 260)
	image.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)

# Now save
	var imageResult = image.save_png(save_path + "/" + str(number) + ".png")
	if imageResult != OK:
		print("Failed to save image. Error code:", imageResult)
	else:
		print("Saved to:", ProjectSettings.globalize_path(save_path + str(number) + ".png"))
	
	if isSerial:
		new_card.serialise(self.serialNum, self.serialMaxNum)
		new_card.setPrice(serialPriceAduster(self.serialNum, new_card.price))
	
	new_card.call_deferred("loadImage")
	finished();
	queue_free();
	pass

func finished ():
	if is_instance_valid(httpRequest1):
		httpRequest1.queue_free()
	if is_instance_valid(httpRequest2):
		httpRequest2.queue_free()
	#for child in Player.get_children(): 
		#print(child.ID)
	if self.isLast:
		#print("Child count: ", HttpData.get_child_count())
		HttpData.emit_signal("Finished")
		#print("done")

func createID() -> String:
	var foil: String;
	match isFoil:
		0: foil =  ""
		1: foil = "f"
		2: foil = "ef"
		3: foil = "cf"
		5: foil = "z" + str(serialNum)
	#print("ID created: " + set_name + str(number) + foil)
	return set_name + str(number) + foil;

func startPing ():
	#print("new card made!")
	httpRequest1 = HTTPRequest.new();
	HttpData.add_child(httpRequest1);
	httpRequest1.request_completed.connect(firstPing);
	var url = "https://api.scryfall.com/cards/%s/%d?lang=en" % [set_name.to_lower(), number]
	httpRequest1.request(url);
	pass

func serialPriceAduster (number, price) -> float:
	
	match number:
		100, 200, 300, 400, 500:
			price = price * 1.35
		1:
			price = pow(price, 1.1) * 1.4
		2: 
			price = price * 1.4
		3:
			price = price * 1.34
		4:
			price = price * 1.32
		5:
			price = price * 1.31
		10, 20, 30, 40, 50, 150, 250, 350, 450:
			price = price * 1.2
		69: 
			price = price * 1.35
		169, 269, 369, 469:
			price = price * 1.15
		111,222,333,444:
			price = price * 1.25
	return price + sin(serialNum)

func get_safe_float(prices: Dictionary, key: String, ID: String) -> float:
	var value = prices.get(key)

	# If it's null or missing
	if value == null:
		push_error("Price key '%s' is null for card ID: %s" % [key, self.cardID])
		return 0.0

	# If it's a string, check if it's numeric
	if typeof(value) == TYPE_STRING:
		if not value.is_valid_float():
			push_error("Invalid string '%s' for key '%s' (card ID: %s)" % [value, key, ID])
			return 0.0
		value = float(value)

	# If it's already a float or int, this is fine
	elif typeof(value) in [TYPE_FLOAT, TYPE_INT]:
		return float(value)

	# Everything else (Array, Dictionary, etc.) is invalid
	else:
		push_error("Unexpected type %s for key '%s' (card ID: %s)" % [typeof(value), key, ID])
		return 0.0

	return float(value)
