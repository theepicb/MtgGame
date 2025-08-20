extends Node2D

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

func _ready():
	# Initialize some example packs
	create_pack("mat_ep", 4.5, preload("res://sprites/Packs/MOTM-E-pack.png"), 2)
	unlock_pack("mat_ep");
	$"../Pack_Clicker".unlockedCommonPacks.append("mat_ep")
	create_pack("mat_col", 25, preload("res://sprites/Packs/collector booster motm.jpg"), 25)
	create_pack("woe_draft", 10, preload("res://sprites/Packs/eldraine_draft.png"), 10)
	create_pack("woe_set", 13, preload("res://sprites/Packs/eldraine_set.png"), 13)
	create_pack("woe_col", 45, preload("res://sprites/Packs/woe_collector.png"), 45)
	# Layout all unlocked packs
	

func create_pack(id: String, price: float, texture: Texture2D, xp: int):
	var new_pack = Pack.new(id, price, texture, xp)
	packs.append(new_pack)
	# Uncomment if you want packs unlocked by default
	#new_pack.unlocked = true

func layout_pack_buttons():
	var start_x = 220
	var start_y = 20
	var columns = 4
	var button_width = 220
	var button_height = 320
	var horizontal_spacing = 20
	var vertical_spacing = 30
	
	var row = 0
	var col = 0
	
	# Clear existing buttons first
	for child in get_children():
		if child is Button:
			child.queue_free()
	
	for pack in packs:
		if pack.unlocked:
			# Create button
			var button = Button.new()
			button.custom_minimum_size = Vector2(button_width, button_height)
			button.position = Vector2(
				start_x + col * (button_width + horizontal_spacing),
				start_y + row * (button_height + vertical_spacing)
			)
			
			# Create container for centered content
			var container = VBoxContainer.new()
			container.size = Vector2(button_width, button_height)
			container.alignment = BoxContainer.ALIGNMENT_CENTER
			
			# Create texture rect for sprite
			var texture_rect = TextureRect.new()
			texture_rect.texture = pack.sprite_texture
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture_rect.custom_minimum_size = Vector2(button_width - 30, button_height - 70)
			
			# Create price label (centered)
			var price_label = Label.new()
			price_label.text = "cost: " + "$%.2f" % pack.price
			price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			# Create owned label (centered)
			var owned_label = Label.new()
			owned_label.name = "OwnedLabel"
			owned_label.text = "Owned: %d" % pack.owned
			owned_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
			# Add elements to container
			container.add_child(texture_rect)
			container.add_child(price_label)
			container.add_child(owned_label)
			
			# Add container to button
			button.add_child(container)
			
			# Connect button press
			button.pressed.connect(_on_pack_button_pressed.bind(pack))
			
			# Store button reference
			pack.button = button
			add_child(button)
			
			# Update grid position
			col += 1
			if col >= columns:
				col = 0
				row += 1

func _on_pack_button_pressed(pack: Pack):
	if money_manager.money >= pack.price:
		money_manager.money -= pack.price
		pack.owned += 1
		
		# Update owned count display
		var container = pack.button.get_child(0) as VBoxContainer
		if container:
			var owned_label = container.get_node("OwnedLabel") as Label
			if owned_label:
				owned_label.text = "Owned: %d" % pack.owned
		
		print("Purchased %s pack! Total owned: %d" % [pack.id, pack.owned])
	else:
		print("Not enough money to buy %s pack!" % pack.id)

func unlock_pack(pack_id: String):
	for pack in packs:
		if pack.id == pack_id:
			pack.unlocked = true
			break
			
func deleteChildren():
	for child in get_children():
		if child is Button:
			child.queue_free()
