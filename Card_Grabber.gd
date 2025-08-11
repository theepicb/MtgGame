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

var httpRequest1: HTTPRequest;
var httpRequest2: HTTPRequest;

var imageURL: String;

var isLast: bool
var new_card: Card



func _init(number:int, set_name: String, foilEnum: int, save_path: String, position: Vector2, isLast: bool) -> void:
	# defining variables
	self.number = number;
	self.set_name = set_name;
	self.isFoil = foilEnum;
	self.save_path = save_path + "/";
	self.cardID = createID()
	self.pos = position
	self.isLast = isLast
	
	# create new instance of card then adds it as a child of the player
	
	
	# cards currently being shown as pack
	
	#card inventory
	
	generateCard();
	print("started card generation", save_path)
	pass

func generateCard () -> void:
	if !Player.IDInventory.has(self.cardID):
		print("inventory ", Player.IDInventory)
		self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number) + ".png"), pos)
		Player.add_child(new_card)
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
					self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number) + ".png"), pos)
					Player.add_child(new_card)
					Player.cardsToShow.push_back(new_card);
					Player.cardsToDelete.push_back(new_card)
					finished();
					return
					pass
		self.new_card = Card.new(1,  cardID, self.isFoil, ProjectSettings.globalize_path(save_path + "/" + str(number) + ".png"), pos)
		Player.add_child(new_card)
		Player.cardsToShow.push_back(new_card);
		Player.cardsToDelete.push_back(new_card)
		startPing();
		pass
	pass

func firstPing (result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		push_error("API request failed with code: %d" % response_code)
		return
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	if not json:
		push_error("Failed to parse JSON response")
		return
	
	var cardname = json.get("name", "Unknown Card")
	new_card.setName(cardname)
	# Handle price
	var prices = json.get("prices", {})
	
	match isFoil:
		0: card_value = float(prices.get("usd", 0.0))
		1: card_value = float(prices.get("usd_foil", 0.0))
		2: card_value = float(prices.get("usd_etched", 0.0))
		3: card_value = float(prices.get("halo_foil", 0.0))
	print(json.get("image_uris", {}))
	var image_uris = json.get("image_uris", {})
	imageURL = image_uris["png"];
	if not image_uris.has("png"):
		push_error("No PNG image available for this card")
		return
	pass
	new_card.setPrice(card_value)
	if FileAccess.file_exists(ProjectSettings.globalize_path(save_path + "/" + str(number) + ".png")):
		print("image exists!")
		new_card.call_deferred("loadImage")
		finished()
	else:
		httpRequest2 = HTTPRequest.new();
		HttpData.add_child(httpRequest2)
		httpRequest2.request_completed.connect(secondPing);
		httpRequest2.request(image_uris["png"])

func secondPing (result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		push_error("Image download failed with code: %d" % response_code)
		return
	
	var image = Image.new()
	if image.load_png_from_buffer(body) != OK:
		push_error("Failed to load image from buffer")
		return
	var size = image.get_size();
	var new_size = Vector2(186, 260)
	image.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)

# Now save
	var imageResult = image.save_png(save_path + str(number) + ".png")
	if imageResult != OK:
		print("Failed to save image. Error code:", imageResult)
	else:
		print("Saved to:", ProjectSettings.globalize_path(save_path + str(number) + ".png"))
	
	new_card.call_deferred("loadImage")
	finished();
	queue_free();
	pass

func finished ():
	if is_instance_valid(httpRequest1):
		httpRequest1.queue_free()
	if is_instance_valid(httpRequest2):
		httpRequest2.queue_free()
	for child in Player.get_children(): 
		print(child.ID)
	if self.isLast:
		print("Child count: ", HttpData.get_child_count())
		HttpData.emit_signal("Finished")
		print("done")

func createID() -> String:
	var foil: String;
	match isFoil:
		0: foil =  ""
		1: foil = "f"
		2: foil = "ef"
		3: foil = "sf"
	print("ID created: " + set_name + str(number) + foil)
	return set_name + str(number) + foil;

func startPing ():
	print("new card made!")
	httpRequest1 = HTTPRequest.new();
	HttpData.add_child(httpRequest1);
	httpRequest1.request_completed.connect(firstPing);
	var url = "https://api.scryfall.com/cards/%s/%d" % [set_name, number];
	httpRequest1.request(url);
	pass
