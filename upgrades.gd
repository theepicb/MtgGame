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

func _ready():
	# Register initial available upgrades
	register_upgrade(Upgrade.new(
		"better_clicks1",
		5.0,
		"Increase click value +0.01c per click",
		func(): 
			$"../Money_Clicker".money_per_click += .01;
			register_upgrade(Upgrade.new(
				"better_clicks2",
				12.5,
				"Increase click value +0.01c per click",
				func():
					$"../Money_Clicker".money_per_click += .01;
					return true;
			))
			return true
	))
	
	register_upgrade(Upgrade.new(
		"auto_clicker1",
		2.0,
		"Generates 1c per second",
		func():
			$"../Money_Clicker".money_per_second += 0.01
			return true
	))
	
	register_upgrade(Upgrade.new(
		"unlock_mat_collector",
		2.0,
		"unlocks march of the machine aftermath collector boosters",
		func():
			$"../Pack_Screen".unlock_pack("mat_col")
			return true
	))

func register_upgrade(upgrade: Upgrade):
	available_upgrades.append(upgrade)

func create_upgrade_buttons():
	# Clear existing buttons first
	for child in get_children():
		if child is Button:
			child.queue_free()
	
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
	var parent = $"../Player";
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
