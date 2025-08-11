extends Node2D

class_name UpgradeManager

signal upgrade_purchased(upgrade_id)

class Upgrade:
	var id: String
	var price: float
	var description: String
	var effect: Callable
	
	func _init(p_id: String, p_price: float, p_desc: String, p_effect: Callable):
		id = p_id
		price = p_price
		description = p_desc
		effect = p_effect
		
var available_upgrades: Array[Upgrade] = []  # Upgrades not yet purchased
var purchased_upgrades: Array[Upgrade] = []  # Track purchased upgrades

func register_upgrade(upgrade: Upgrade):
	available_upgrades.append(upgrade)

@onready var parent = $"../Player";


func create_upgrade_buttons():
	# Clear existing buttons first
	for child in get_children():
		if child is Button:
			child.queue_free()
	print(available_upgrades)
	# Create buttons for available upgrades
	for i in available_upgrades.size():
		var upgrade = available_upgrades[i]
		var button = Button.new()
		button.text = "%s - $%.2f" % [upgrade.description, upgrade.price]
		button.position = Vector2(210, 20 + i * 70)
		button.size = Vector2(700, 65)
		button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade))
		add_child(button)

func _on_upgrade_button_pressed(upgrade: Upgrade):
	if parent.money >= upgrade.price:
		if upgrade.effect.call():  # Apply upgrade effect
			parent.money -= upgrade.price
			purchased_upgrades.append(upgrade)
			available_upgrades.erase(upgrade)
			emit_signal("upgrade_purchased", upgrade.id)
			
			# Refresh buttons to remove purchased upgrade
			create_upgrade_buttons();

func deleteChildren():
	for child in get_children():
		if child is Button:
			child.queue_free()

# for upgrade functions remember it is being called from child so use ../../ to grab node path
func increaseClickerValue (amount: float):
	$"../../Money_Clicker".money_per_click += amount;

func registorPack(PackID: String, packRarity: String):
	$"../../Pack_Screen".unlock_pack(PackID)
	match packRarity:
		"common": $"../../Pack_Clicker".unlockedCommonPacks.push_back(PackID)
		"uncommon": $"../../Pack_Clicker".unlockedUncommonPacks.push_back(PackID)
		"rare": $"../../Pack_Clicker".unlockedRarePacks.push_back(PackID)

func increaseMPSValue(amount: float):
	$"../../Money_Clicker".money_per_second += 0.01
	
