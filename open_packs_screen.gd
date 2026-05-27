extends Control

@onready var pack_manager =  $"../../Pack_Screen";
var nodesToShow = ["Click_Screen_button", "Upgrades_Button", "Pack_Screen_Button", "Open_Packs_Screen", "Inventory_Button", "level_Label"]

func _ready() -> void:
	hide()
	_on_viewport_resized()
	get_viewport().size_changed.connect(_on_viewport_resized)
	size = get_viewport_rect().size
	offset_left = 200
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.add_theme_constant_override("margin_top", 30)
	margin_container.add_theme_constant_override("margin_bottom", 30)
	margin_container.add_theme_constant_override("margin_left", 20)
	margin_container.add_theme_constant_override("margin_right", 20)
	scroll.offset_top = 0
	scroll.offset_right = 0
	scroll.offset_bottom = 0
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 30)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
		


@onready var grid = $"ScrollContainer/MarginContainer/GridContainer"
@onready var margin_container = $"ScrollContainer/MarginContainer"
@onready var scroll = $"ScrollContainer"
var button_width = 220
var button_height = 320
func display_owned_packs():
	# Clear existing buttons
	for child in grid.get_children():
		child.queue_free()
	print(scroll.visible)
	print(grid)
	# Filter packs you own more than 1 of
	var owned_packs = pack_manager.packs.filter(func(p): return p.owned > 0)
	
	for pack in owned_packs:
		# Create button
		var button = Button.new()
		button.custom_minimum_size = Vector2(button_width, button_height)

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
		grid.add_child(button)
		
		# Update grid position
	show()
	$ScrollContainer.show()
	_on_viewport_resized()


func _on_pack_opened(pack):
	if pack.owned > 0:
		pack.owned -= 1
		open_pack_contents(pack.id)
		Player.xp += pack.xp
		display_owned_packs()
		
		


func open_pack_contents(pack_id: String):
	print("Opening pack: ", pack_id)
	hideUI();
	match pack_id:
		"mat_ep":
			$"../../Pack_Data/Mat_data".createDraftPack();
			pass
		"mat_col":
			$"../../Pack_Data/Mat_data".createCollectorPack();
			pass
		"woe_draft":
			$"../../Pack_Data/Woe_data".createDraftPack();
			pass
		"woe_set":
			$"../../Pack_Data/Woe_data".createSetPack();
			pass
		"woe_col":
			$"../../Pack_Data/Woe_data".createCollectorPack();
			pass
		"rvr_draft":
			$"../../Pack_Data/Rvr_data".createDraftPack();
			pass
		"rvr_col":
			$"../../Pack_Data/Rvr_data".createCollectorPack()
			pass
		"mom_draft":
			$"../../Pack_Data/Mom_data".createDraftPack()
		"mom_set":
			$"../../Pack_Data/Mom_data".createSetPack()
		"mom_col":
			$"../../Pack_Data/Mom_data".createCollectorPack()
		"lci_draft":
			$"../../Pack_Data/Lci_data".createDraftPack()
		"lci_set":
			$"../../Pack_Data/Lci_data".createSetPack()
	
	# You might call something like:
	# card_reward_system.generate_rewards(pack_id)
func deleteChildren():
	print("hiding")
	print($ScrollContainer.visible)
	hide()
	for child in grid.get_children():
		child.queue_free()

func hideUI () -> void:
	deleteChildren()
	$ScrollContainer.hide()
	$ScrollContainer/MarginContainer/GridContainer.hide()
	$"../Inventory_Button".hide()
	$"../Open_Pack_Button".hide()
	$"../Click_Screen_button".hide()
	$"../Upgrades_Button".hide()
	$"../Pack_Screen_Button".hide()
	
	print("children: ", get_children())

func showUI () -> void:
	$ScrollContainer/MarginContainer/GridContainer.show()
	$"../Click_Screen_button".show()
	$"../Upgrades_Button".show()
	$"../Pack_Screen_Button".show()
	$"../Inventory_Button".show()
	$"../Open_Pack_Button".show()
	display_owned_packs();


func _on_viewport_resized():
	
	var viewport_size = get_viewport_rect().size
	grid.columns = max(1, floor((viewport_size.x - 200) / (button_width + 20)))
