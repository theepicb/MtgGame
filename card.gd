extends Sprite2D
class_name Card
# card object
# shader data
var shader_material 
var shader_time = randi_range(0, 10)
# amount owned
var count: int
# price of card
var price: float
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
		print("invalid card gen")
		queue_free()
		return

	self.count = count
	self.ID = ID
	self.foil = foil
	self.image_path = image_path
	self.pos = pos
	self.shader_material = preload("res://new_shader_material.tres")
	self.scale = Vector2(1, 1)
	self.serial = serial

func _ready():
	z_index = 100
	self.visible = false
	
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

func showCard(posX, posY, scale1) -> void:

	if scale1 <= 0:
		scale1 = 1

	self.visible = true
	self.position = Vector2(posX, posY)
	self.pos = Vector2(posX, posY)
	self.scale = Vector2(scale1, scale1)
	if serial:
		drawSerial(self.serial_number)

func _process(delta):
	if self.foil == 1:
		shader_time += delta / 1.5
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



func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Player.inInventory == true:
		for child in self.get_children():
			if child is Button:
				child.queue_free()
		var click_pos = event.position
		if get_rect().has_point(to_local(click_pos)):
			var button = Button.new();
			self.add_child(button)
			button.size = Vector2(60, 20);
			button.text = ("sell card: " + cardName)
			button.z_index = 101
			button.position = to_local(event.position)
			button.connect("pressed", Callable(self, "sellCard"))

func deleteChildren():
	for child in self.get_children():
		child.queue_free()

func sellCard ():
	if self.count > 0:
		self.count -= 1
		Player.money += self.price
		self.displayUI()
		if self.count <= 0:
			for i in range(Player.IDInventory.size()):
				if Player.IDInventory[i] == self.ID:
					Player.IDInventory.remove_at(i)
					break
			var idx = Player.cardInventory.find(self)
			if idx != -1:
				Player.cardInventory.remove_at(idx)
			Player.reloadInv()
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
	self.price = (pow(self.price, 2) * 2) + 80
	self.ID = self.ID + "z"
	self.serial = true
	self.max_number = maxNumber
	drawSerial(self.serial_number)

func drawSerial (number):
	var serial = Sprite2D.new()
	self.add_child(serial)
	var image = Image.new()
	var result = image.load("res://serialised.png")
	# Use this instead of create_from_image
	var tex = ImageTexture.create_from_image(image)  # You can adjust flags if needed
	serial.texture = tex
	serial.scale = Vector2(0.35, 0.35)
	serial.position = Vector2(-43, -0.5)
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
	serialNum.position = Vector2(-62, -7)
	add_child(serialNum)
	
	var SerialNumMax = Label.new()
	SerialNumMax.add_theme_font_size_override("font_size", 9)
	SerialNumMax.text = str(max_number)
	SerialNumMax.position = Vector2(-38, -7)
	self.add_child(SerialNumMax)
	
	self.foil = 5
	var mat = preload("res://DoubleRainbowFoil.tres")
	mat.set_shader_parameter("time", shader_time)
	self.material = mat
	serial.material = mat
	serialNum.material = mat
	SerialNumMax.material = mat
