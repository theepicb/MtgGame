extends Button

@onready var pack_manager =  $"../../Pack_Screen";

func _ready():
	size = Vector2(180, 60)
	position = Vector2(2, 185)
	text = "open packs"
	pass 

func _pressed() -> void:
	$"../../Money_Clicker".visible = false;
	$"../../Pack_Clicker".visible = false;
	$"../../Upgrades".deleteChildren();
	$"../../Pack_Screen".deleteChildren();
	display_owned_packs();
	pass

func display_owned_packs():
	# Clear existing buttons
	for child in get_children():
		if child is Button:
			child.queue_free()
	
	var start_x = 220
	var start_y = -180
	var columns = 4
	var button_width = 220
	var button_height = 320
	var spacing = 30
	
	var row = 0
	var col = 0
	
	# Filter packs you own more than 1 of
	var owned_packs = pack_manager.packs.filter(func(p): return p.owned > 0)
	
	for pack in owned_packs:
		# Create button
		var button = Button.new()
		button.custom_minimum_size = Vector2(button_width, button_height)
		button.position = Vector2(
			start_x + col * (button_width + spacing),
			start_y + row * (button_height + spacing)
		)
		
		# Create container
		var container = VBoxContainer.new()
		container.size = Vector2(button_width, button_height)
		container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# Add pack image
		var texture_rect = TextureRect.new()
		texture_rect.texture = pack.sprite_texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(button_width - 30, button_height - 70)
		
		# Add owned count
		var count_label = Label.new()
		count_label.text = "Owned: %d" % pack.owned
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		# Add open button text
		var open_label = Label.new()
		open_label.text = "OPEN PACK"
		open_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		# Assemble UI
		container.add_child(texture_rect)
		container.add_child(count_label)
		container.add_child(open_label)
		button.add_child(container)
		
		# Connect press signal
		button.pressed.connect(_on_pack_opened.bind(pack))
		add_child(button)
		
		# Update grid position
		col += 1
		if col >= columns:
			col = 0
			row += 1


func _on_pack_opened(pack):
	if pack.owned > 0:
		pack.owned -= 1
		open_pack_contents(pack.id)
		display_owned_packs()
		
		


func open_pack_contents(pack_id: String):
	print("Opening pack: ", pack_id)
	# Add your pack opening logic here
	# This could show cards, add items to inventory, etc.
	
	# Example card rewards - replace with your actual logic
	match pack_id:
		"mat_ep":
			hideUI();
			$"../../Pack_Data/Mat_data".createDraftPack();
			pass
		"mat_col":
			print("You got 5 premium cards!")
	
	# You might call something like:
	# card_reward_system.generate_rewards(pack_id)
func deleteChildren():
	for child in get_children():
		if child is Button:
			child.queue_free()

func hideUI () -> void:
	deleteChildren()
	for child in $"..".get_children():
		child.visible = false
		
