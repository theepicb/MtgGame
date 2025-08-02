extends Sprite2D
class_name Card

var shader_material 
var shader_time = 0.0

var count: int
var price: float
var ID: String
var foil: int
var image_path: String
var pos: Vector2

func _init(count: int, price: float, ID: String, foil: int, image_path: String, pos: Vector2):
	self.count = count
	self.price = price
	self.ID = ID
	self.foil = foil
	self.image_path = image_path
	self.pos = pos
	self.shader_material = preload("res://new_shader_material.tres")

func _ready():
	z_index = 100
	self.visible = false
	
	var success = load_png_to_sprite(image_path)
	print("foil", self.foil)
	if self.foil == 1:
		self.material = preload("res://new_shader_material.tres")
		self.material.set_shader_parameter("time", shader_time)
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

func showCard (posX, posY) -> void:
	self.visible = true;
	self.position = Vector2(posX, posY);
	pass

func _process(delta):
	if self.foil == 1:
		shader_time += delta
		if self.material:
			self.material.set_shader_parameter("time", shader_time)
	pass

func displayPrice():
	var container = VBoxContainer.new()
	container.anchor_left = 0
	container.anchor_right = 0
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	container.add_child(self)
	var price = Label.new()
	add_child(price)
	price.text = "$" + str(self.price)
	price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price.set_anchors_preset(Control.PRESET_CENTER)
	price.set_position(Vector2(-25, 130))
	
	container.add_child(price)
	
