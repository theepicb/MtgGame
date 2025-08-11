extends Sprite2D
class_name Card

var shader_material 
var shader_time = randi_range(0, 10)

var count: int
var price: float
var ID: String
var foil: int
var image_path: String
var pos: Vector2
var cardName: String

func _init(
	count: int = -1,
	ID: String = "",
	foil: int = -1,
	image_path: String = "",
	pos: Vector2 = Vector2.ZERO
):
	if count == -1 or ID == "" or foil == -1 or image_path == "":
		# No valid data — delete self
		queue_free()
		return

	self.count = count
	self.ID = ID
	self.foil = foil
	self.image_path = image_path
	self.pos = pos
	self.shader_material = preload("res://new_shader_material.tres")
	self.scale = Vector2(1, 1)

func _ready():
	z_index = 100
	self.visible = false
	
	
	print("foil", self.foil)
	if self.foil == 1:
		self.material = preload("res://new_shader_material.tres")
		self.material.set_shader_parameter("time", shader_time)
		self.material.set_shader_parameter("rainbow_opacity", 0.1)
	elif self.foil == 2:
		var mat = preload("res://Etched.tres")
		mat.set_shader_parameter("time", shader_time)
		self.material = mat
	elif foil == 0:
		var mat = preload("res://Card.tres")
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
	print("✅ Texture created. Texture size:", self.texture.get_size())

	return true

func showCard(posX, posY, scale1) -> void:
	print("showCard called with scale:", scale1)
	if scale1 <= 0:
		scale1 = 1

	self.visible = true
	self.position = Vector2(posX, posY)
	self.pos = Vector2(posX, posY)
	self.scale = Vector2(scale1, scale1)

func _process(delta):
	if self.foil == 1:
		shader_time += delta / 1.5
		if self.material:
			self.material.set_shader_parameter("time", shader_time)
	pass

func displayPrice():
	var container = VBoxContainer.new()
	container.anchor_left = 0
	container.anchor_right = 0
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var price = Label.new()
	add_child(price)
	price.text = "$" + str(self.price)
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
	price.text = "$" + str(self.price) + "    amount: " + str(self.count)
	price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price.set_anchors_preset(Control.PRESET_CENTER)
	price.set_position(Vector2(-65, 130))




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
