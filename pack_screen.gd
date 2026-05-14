extends Control

class_name PackManager
static var instance = null

func _init():
	if instance != null:
		queue_free()  # Another instance exists, remove this one
		return
	instance = self

# Pack class definition
class Pack:
	var id: String
	var price: float
	var unlocked: bool
	var owned: int
	var sprite_texture: Texture2D
	var button: Button
	var xp: int
	
	func _init(p_id: String, p_price: float, p_texture: Texture2D, xp_earnt: int):
		id = p_id
		price = p_price
		sprite_texture = p_texture
		unlocked = false
		owned = 0
		xp = xp_earnt

# Main variables
var packs: Array[Pack] = []
@onready var money_manager = Player # Assume you have a node tracking money
@onready var grid = get_node("/root/Main/Pack_Screen/Open_Packs_Screen_scroller/MarginContainer/GridContainer")
@onready var scroll = $Open_Packs_Screen_scroller
@onready var margin_container = $Open_Packs_Screen_scroller/MarginContainer

	
func _ready():
	get_viewport().size_changed.connect(_on_viewport_resized)
	size = get_viewport_rect().size
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.add_theme_constant_override("margin_top", 30)
	margin_container.add_theme_constant_override("margin_bottom", 30)
	margin_container.add_theme_constant_override("margin_left", 20)
	margin_container.add_theme_constant_override("margin_right", 20)
	scroll.offset_left = 200
	scroll.offset_top = 0
	scroll.offset_right = 0
	scroll.offset_bottom = 0
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 30)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Initialize some example packs
	create_pack("mat_ep", 4, preload("res://sprites/Packs/MOTM-E-pack.png"), 2)
	unlock_pack("mat_ep");
	
	
	$"../Pack_Clicker".unlockedCommonPacks.append("mat_ep")
	create_pack("mat_col", 25, preload("res://sprites/Packs/collector booster motm.jpg"), 25)
	create_pack("woe_draft", 5.5, preload("res://sprites/Packs/eldraine_draft.png"), 10)
	create_pack("woe_set", 12, preload("res://sprites/Packs/eldraine_set.png"), 13)
	create_pack("woe_col", 60, preload("res://sprites/Packs/woe_collector.png"), 45)
	create_pack("rvr_draft", 15, preload("res://sprites/Packs/Rvr_draft.png"), 12)
	create_pack("rvr_col", 75, preload("res://sprites/Packs/Rvr_collector.png"), 75)
	create_pack("mom_draft", 10, preload("res://sprites/Packs/Mom_draft.png"), 10)
	create_pack("mom_set", 15, preload("res://sprites/Packs/Mom_set.png"), 15)
	create_pack("mom_col", 80, preload("res://sprites/Packs/mom_collector.png"), 80)
	create_pack("lci_draft", 0, preload("res://sprites/Packs/LCI_draft.png"), 12)
	create_pack("lci_set", 0, preload("res://sprites/Packs/LCI_set.png"), 12)
	# Layout all unlocked packs
	unlock_pack("lci_draft")
	unlock_pack("lci_set")

func returnDictionary () -> Dictionary:
	var dict = {}
	for pack in packs:
		dict[pack.id] = {
			"id": pack.id,
			"price": pack.price,
			"owned": pack.owned,
			"unlocked": pack.unlocked
		}
	print(dict)
	return dict

func setDictionary(input: Dictionary):
	for item in input.keys():
		for pack in packs:
			if item == pack.id:
				#print("unlocked:: ", item["unlocked"])
				if input[item]["unlocked"]:
					unlock_pack(pack.id)
					
				pack.price = input[item]["price"]
				pack.owned = input[item]["owned"]

func create_pack(id: String, price: float, texture: Texture2D, xp: int):
	var new_pack = Pack.new(id, price, texture, xp)
	packs.append(new_pack)
	# Uncomment if you want packs unlocked by default

var button_width = 200
var button_height = 280

func layout_pack_buttons():
	
	size = get_viewport_rect().size
	print(scroll)
	print(grid)
	_on_viewport_resized()
	# Remove old buttons
	for child in grid.get_children():
		child.queue_free()

	

	# Automatically calculate columns

	for pack in packs:

		if pack.unlocked or Player.godMode:

			var button = Button.new()
			button.custom_minimum_size = Vector2(button_width, button_height)

			# Main vertical container
			var container = VBoxContainer.new()
			container.custom_minimum_size = Vector2(button_width, button_height)
			container.alignment = BoxContainer.ALIGNMENT_CENTER

			# Pack image
			var texture_rect = TextureRect.new()
			texture_rect.texture = pack.sprite_texture
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture_rect.custom_minimum_size = Vector2(
				button_width - 30,
				button_height - 70
			)

			# Price label
			var price_label = Label.new()
			price_label.text = "Cost: $%.2f" % pack.price
			price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

			# Owned label
			var owned_label = Label.new()
			owned_label.name = "OwnedLabel"
			owned_label.text = "Owned: %d" % pack.owned
			owned_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

			# Add UI elements
			container.add_child(texture_rect)
			container.add_child(price_label)
			container.add_child(owned_label)

			button.add_child(container)

			# Button signal
			button.pressed.connect(
				_on_pack_button_pressed.bind(pack)
			)

			pack.button = button

			# Add to grid container
			grid.add_child(button)
	self.show()
	print("Children in grid: ", grid.get_child_count())
	print("Grid size: ", grid.size)
	print("Scroll size: ", scroll.size)

func _on_pack_button_pressed(pack: Pack):
	if Player.godMode:
		pack.owned += 1
	elif money_manager.money >= pack.price:
		money_manager.money -= pack.price
		pack.owned += 1
	
	# Update owned count display
	var container = pack.button.get_child(0) as VBoxContainer
	if container:
		var owned_label = container.get_node("OwnedLabel") as Label
		if owned_label:
			owned_label.text = "Owned: %d" % pack.owned


func unlock_pack(pack_id: String):
	for pack in packs:
		if pack.id == pack_id:
			pack.unlocked = true
			break
			
func deleteChildren():
	self.hide()

func getPack (ID: String, amount: int):
	for pack in packs:
		if pack.id == ID:
			pack.owned += amount
			break

func _on_viewport_resized():

	size = get_viewport_rect().size
	
	var columns = max(1, floor((size.x - 200) / (button_width + 20)))

	grid.columns = columns
	
	scroll.size = Vector2(
		size.x - 200,
		size.y 
	)
