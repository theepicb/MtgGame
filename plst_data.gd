extends Node2D
class_name P_list
var set_name = "plst"

var serial_max = 0

var card
var ID
var x
var isLast
func _init(xIn: int = -1, isLastin = true) -> void:
	if xIn == -1:
		self.queue_free()
	self.x = xIn
	self.isLast = isLastin
	

	pass
func _ready() -> void:
	ensure_directory_exists("user://Cards/plst")
	if x != -1:
		generateListCard()

var httpRequest1
var httpRequest2


func generateListCard ():
	httpRequest1 = HTTPRequest.new();
	HttpData.add_child(httpRequest1);
	httpRequest1.request_completed.connect(firstPing);
	var rarity = getRarityByWeight([0, 1, 2, 3],[50, 30, 15, 5])
	var url
	match rarity:
		0:
			url = "https://api.scryfall.com/cards/random?q=set%3Aplst%20rarity%3Acommon%20usd%3E0.01"
		1:
			url = "https://api.scryfall.com/cards/random?q=rarity%3Auncommon%20usd%3E0.01"
		2:
			url = "https://api.scryfall.com/cards/random?q=rarity%3Arare%20usd%3E0.01"
		3:
			url = "https://api.scryfall.com/cards/random?q=rarity%3Amythic%20usd%3E0.01"
	httpRequest1.request(url);
	
func firstPing(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		push_error("API request failed number")
		finish()
		return
	print("JSON HAPPENED")
	var json = JSON.parse_string(body.get_string_from_utf8())
	if typeof(json) != TYPE_DICTIONARY:
		push_error("Invalid JSON response")
		return
	print(json)
	ID = json.get("id")
	if Player.cardInventory.has(ID):
		Player.cardInventory[ID] += 1
		Player.add_child(card)
		Player.cardsToShow.push_back(card);
		Player.cardsToDelete.push_back(card)
		finish()
		return
	else:
		var prices = json.get("prices")
		print("is foil? ", prices.get("usd_foil"))
		if (prices.get("usd") != "<null>"):
			createCard(prices.get("usd", 0), json.get("name", "unknown name"), 0)
		else:
			createCard(prices.get("usd_foil", 0), json.get("name", "unknown name"), 1)
		Player.cardInventory[ID] = card
		Player.cardsToShow.push_back(card);
	if FileAccess.file_exists(ProjectSettings.globalize_path("user://Cards/plst" + "/" + ID + ".png")):
		card.call_deferred("loadImage")
		finish()
		return
	
	var image_uris = json.get("image_uris", {})
	if image_uris.is_empty() and json.has("card_faces"):
		var card_faces = json["card_faces"]
		if card_faces.size() > 0:
			var front_face = card_faces[0]
			if front_face.has("image_uris"):
				image_uris = front_face["image_uris"]
	
	httpRequest2 = HTTPRequest.new()
	HttpData.add_child(httpRequest2);
	httpRequest2.request_completed.connect(secondPing);
	httpRequest2.request(image_uris["png"])

func secondPing (result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass
	if response_code != 200:
		push_error("Image download failed with code: %d" % response_code)
		return
	
	var image = Image.new()
	if image.load_png_from_buffer(body) != OK:
		push_error("Failed to load image from buffer")
		return
	var new_size = Vector2(186.25, 260)
	image.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)

 #Now save
	var imageResult = image.save_png("user://Cards/plst" + "/" + ID + ".png")
	if imageResult != OK:
		print("Failed to save image. Error code:", imageResult)
	else:
		print("Saved to:", ProjectSettings.globalize_path("user://Cards/plst" + "/" + ID + ".png"))
	
	
	card.call_deferred("loadImage")
	finish()
	pass
#
func createCard (price, card_name, foil):
	card = Card.new(1, ID, foil,"user://Cards/plst" + "/" + ID + ".png" , getPosition(x), false)
	card.setPrice(price)
	card.set_name(card_name)
	Player.add_child(card)


func getPosition(x) -> Vector2:
	var pos = Vector2(100 + ((x % 10) * 200), 200 + (290 *(floor(x/ 10))))
	return pos

func finish():
	if is_instance_valid(httpRequest1):
		httpRequest1.queue_free()
		httpRequest1 = null
	if is_instance_valid(httpRequest2):
		httpRequest2.queue_free()
		httpRequest2 = null
		
	if self.isLast:
		HttpData.emit_signal("Finished")
	
	queue_free()



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

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]
