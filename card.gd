extends Sprite2D
class_name Card
# card object
@onready var inventory_button = get_node("/root/Main/CanvasLayer/Inventory_Button")
# shader data
var shader_material 
var shader_time = randf_range(0, 10)
# amount owned
var count: int
# price of card
var price: float

var set_name: String
var set_number: String
# id of the card used for image gathering and double checking
var ID: String
# foil enum 0: not foil, 1: foil, 2: etched foil, 3: confetti foil.
# used for shader and price gathering
var foil: int
# image location in file
var image_path: String
# Sprite2D location on screen
var pos: Vector2
# name of the card
var cardName: String
# is serialised
var serial: bool
# serial number
var serial_number: int
var max_number: int

var image_init = false
func _init(
	count: int = -1,
	ID: String = "",
	foil: int = -1,
	image_path: String = "",
	pos: Vector2 = Vector2.ZERO,
	serial: bool = false,
	serial_number: int = 0,
	max_number: int = 0
):
	if count == -1 or ID == "" or foil == -1 or image_path == "":
		# No valid data — delete self
		print("invalid card gen", count, ID, foil, image_path)
		queue_free()
		return
	self.count = count
	self.ID = ID
	self.foil = foil
	self.image_path = image_path
	self.pos = pos
	self.scale = Vector2(1, 1)
	self.serial = serial
	self.set_name = ID.substr(0, 3)
	self.set_number = ID.substr(3)

func _ready():
	z_index = 100
	self.visible = false
	self.set_name = self.ID.substr(0, 3)
	var mat = -1
	print("foil", self.foil)
	match self.foil:
		0:
			mat = preload("res://Card.tres")
			pass
		1:
			mat = preload("res://new_shader_material.tres")
			pass
		2: 
			mat = preload("res://Etched.tres")
			pass
		3:
			mat = preload("res://Confetti.tres")
			pass
		4:
			mat = preload("res://texturedFoil.tres")
			pass
		5:
			mat = preload("res://DoubleRainbowFoil.tres")
			pass
	if mat is Resource:
		mat.set_shader_parameter("time", shader_time)
		self.material = mat
	else:
		print("mat is not recourse", self.ID)
		
		
		
		
	#print("Card initialized. Texture loaded?", success)
	#print(" - ID:", ID)
	#print(" - Texture is set:", texture != null)
	#print(" - Global position:", global_position)

func load_png_to_sprite(png_path: String) -> bool:
	var image = Image.new()
	var result = image.load(png_path)
	if result != OK:
		print("❌ Failed to load image from:", png_path)
		return false
	
	var size = image.get_size()
	if size == Vector2i(0, 0):
		print("❌ Image loaded but is empty (0x0):", png_path)
		
		return false
	
	print("✅ Image loaded with size:", size)

	# Use this instead of create_from_image
	var tex = ImageTexture.create_from_image(image)  # You can adjust flags if needed

	self.texture = tex
	#print("✅ Texture created. Texture size:", self.texture.get_size())

	return true

func redownload ():
	var grab = Card_Grabber.new(set_number, set_name, self.foil, "user://Cards/" + set_name, Vector2(0, 0), true, true, false)
	add_child(grab)
	await HttpData.Finished
	
func showCard(posX, posY, scale1, offset: float = 0) -> void:

	if scale1 <= 0:
		scale1 = 1

	self.visible = true
	self.position = Vector2(posX, posY + offset)
	self.scale = Vector2(scale1, scale1)
	if serial:
		drawSerial(self.serial_number)

func _process(delta):
	if self.foil == 1:
		self.shader_time += delta / 1.5
		if self.material:
			self.material.set_shader_parameter("time", shader_time)
	else:
		self.shader_time += delta / 1.25
		if self.material:
			self.material.set_shader_parameter("time", shader_time)
	pass

func displayPrice():
	deleteChildren()
	var container = VBoxContainer.new()
	container.anchor_left = 0
	container.anchor_right = 0
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var price = Label.new()
	add_child(price)
	price.text = "$" + str("%1.2f" % self.price)
	price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price.set_anchors_preset(Control.PRESET_CENTER)
	price.set_position(Vector2(-25, 130))
	if serial:
		drawSerial(self.serial_number)

func displayUI():
	deleteChildren()
	var container = VBoxContainer.new()
	container.anchor_left = 0
	container.anchor_right = 0
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var price = Label.new()
	add_child(price)
	price.text = "$" + str("%1.2f" % self.price) + "    amount: " + str(self.count)
	price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price.set_anchors_preset(Control.PRESET_CENTER)
	price.set_position(Vector2(-65, 130))
	if serial:
		drawSerial(self.serial_number)




func setPrice(value):
	self.price = value


func setName (name):
	self.cardName = name

func loadImage ():
	var success = load_png_to_sprite(image_path)
	return success



func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Player.inInventory == true:
		for child in self.get_children():
			if child is Button:
				child.queue_free()
		var click_pos = event.position
		if get_rect().has_point(to_local(click_pos)):
			if inventory_button.currentInv == 0:
				var button = Button.new();
				self.add_child(button)
				button.size = Vector2(60, 20);
				button.text = ("sell card: " + cardName + ", $" + str("%1.2f" % (price * Player.sell_multi)))
				button.z_index = 101
				button.position = to_local(Vector2(event.position.x, event.position.y + 5))
				button.connect("pressed", Callable(self, "sellCard"))
			var moveButton = Button.new()
			self.add_child(moveButton)
			moveButton.size = Vector2(60, 20);
			if inventory_button.currentInv == 0:
				moveButton.position = to_local(Vector2(event.position.x, event.position.y + 40))
				moveButton.text = "move to binder"
			elif inventory_button.currentInv == 1:
				moveButton.position = to_local(Vector2(event.position.x, event.position.y + 5))
				moveButton.text = "move to inventory"
			moveButton.z_index = 101
			
			moveButton.connect("pressed", Callable(self, "moveCard"))

func deleteChildren():
	for child in self.get_children():
		child.queue_free()

func sellCard ():
	if self.count > 0:
		self.count -= 1
		Player.money += self.price * Player.sell_multi
		self.displayUI()
		if self.count <= 0:
			if inventory_button.currentInv == 0:
				for i in range(Player.cardInventory.size()):
					if Player.IDInventory[i] == self.ID:
						Player.IDInventory.remove_at(i)
						break
				Player.cardInventory = Player.cardInventory.filter(func(item): return item.ID != self.ID)
			elif inventory_button.currentInv == 1:
				for i in range(Player.binder.size()):
					if Player.IDbinder[i] == self.ID:
						Player.IDbinder.remove_at(i)
						break
				Player.binder = Player.binder.filter(func(item): return item.ID != self.ID)
			Player.reloadInv()
			self.queue_free()

func moveCard():
	var moving_to_binder = inventory_button.currentInv == 0

	var source_list = Player.cardInventory if moving_to_binder else Player.binder
	var target_list = Player.binder if moving_to_binder else Player.cardInventory
	var target_id_list = Player.IDbinder if moving_to_binder else Player.IDInventory
	var source_id_list = Player.IDInventory if moving_to_binder else Player.IDbinder

	# ---- 1. Try to add to existing stack in target ----
	var found = false
	if target_id_list.has(self.ID):
		for item in target_list:
			if item.ID == self.ID:
				item.count += 1
				found = true
				break

	# ---- 2. If not found, create a new card ----
	if not found:
		print("id: ", self.ID, " foil: ", self.foil, " path: ", image_path)
		var new_card = Card.new(1, self.ID, self.foil, self.image_path, self.pos, self.serial, self.serial_number, self.max_number)
		if self.serial:
			new_card.serial_number = self.serial_number
			new_card.max_number = self.max_number
			new_card.serial = true
		new_card.call_deferred("loadImage")
		new_card.cardName = self.cardName
		new_card.price = self.price
		Player.add_child(new_card)
		target_list.append(new_card)
		target_id_list.append(self.ID)

	# ---- 3. Reduce the original card ----
	self.count -= 1
	self.displayUI()
	# ---- 4. Remove original card if empty ----
	if self.count == 0:
		# Remove from source lists
		source_list = source_list.filter(func(item): return item.ID != self.ID)
		source_id_list = source_id_list.filter(func(id): return id != self.ID)

		# Assign back to Player arrays (important!)
		if moving_to_binder:
			Player.cardInventory = source_list
			Player.IDInventory = source_id_list
		else:
			Player.binder = source_list
			Player.IDbinder = source_id_list
		for item in Player.binder:
			if item.ID == self.ID:
				print("ID copy found with self count: ", self.count)
		
		inventory_button.choseScreenReload()
		inventory_button.loadInventory()
		self.queue_free()
	

func returnDictionary()->Dictionary:
	return {
		"price": self.price,
		"count": self.count,
		"image_path": self.image_path,
		"ID": self.ID,
		"cardName": self.cardName,
		"foil": self.foil,
		"serial": self.serial,
		"serialNum": self.serial_number,
		"serialMax": self.max_number
	}

func serialise (number: int = serial_number, maxNumber: int = max_number) -> void:
	self.serial_number = number
	self.price = (pow(self.price + 5 , 1.5) * 4) + 80
	self.serial = true
	self.max_number = maxNumber
	drawSerial(self.serial_number)

func drawSerial (number):
	var sPos = Vector2(-43, 1)
	match self.set_name:
		"rvr":
			sPos = Vector2(-43, 1)
		"mom":
			sPos = Vector2(-60, 4)
		"mul":
			sPos = Vector2(-54, 4)
	if not is_inside_tree():
		await ready
	var serial = Sprite2D.new()
	self.add_child(serial)
	var image = Image.new()
	var tex = load("res://serialised.png") as Texture2D
	# Use this instead of create_from_image
	serial.texture = tex
	serial.scale = Vector2(0.35, 0.35)
	serial.position = sPos
	serial.visible = true
	var serialNum = Label.new()
	var temp = ""
	if serial_number <= 9:
		temp = "00"
	elif serial_number <= 99:
		temp = "0"
	serialNum.text = temp + str(serial_number)
	serialNum.add_theme_font_size_override("font_size", 9)

# Define a size area for the label
	serialNum.custom_minimum_size = Vector2(100, 20)

# Now alignment makes sense inside that 100x20 box
	serialNum.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	serialNum.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	serialNum.position = Vector2(sPos.x - 19,sPos.y -6.5)
	serialNum.add_theme_color_override("font_color", Color.WHITE)
	add_child(serialNum)
	
	var SerialNumMax = Label.new()
	SerialNumMax.add_theme_font_size_override("font_size", 9)
	SerialNumMax.text = str(max_number)
	SerialNumMax.position = Vector2(sPos.x + 5, sPos.y -6.5)
	SerialNumMax.add_theme_color_override("font_color", Color.WHITE)
	self.add_child(SerialNumMax)
	
	self.foil = 5
	var mat = preload("res://DoubleRainbowFoil.tres")
	var textMat = preload("res://new_shader_material.tres")
	self.material = mat
	serial.material = mat
	serialNum.material = textMat
	SerialNumMax.material = textMat
