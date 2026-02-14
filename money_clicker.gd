extends Button


var money_per_click = 0.01;
var money_per_second = 0;
var money_multiplier = 1;

var combo_crit_chance_multiplier = 0
var combo_crit_multi_multiplier = 0

var timeoutTime = 1;

var combo_wait_time = 1;
var combo = 0;

var max_combo = 100;

var crit_chance = 0
var crit_multi = 2

var doubler = 0;

var rhysticUpgrade = false

func setDictionary (dict: Dictionary):
	money_per_click = dict.get("money_per_click", 0.01)
	money_per_second = dict.get("money_per_second", 0)
	money_multiplier = dict.get("money_multiplier", 0)
	combo_crit_chance_multiplier = dict.get("combo_crit_chance_multiplier", 0)
	combo_crit_multi_multiplier = dict.get("combo_crit_multi_multiplier", 0)
	combo_wait_time = dict.get("combo_wait_time", 1)
	crit_chance = dict.get("crit_chance", 0)
	crit_multi = dict.get("crit_multi", 2)
	doubler = dict.get("doubler", 0)
	rhysticUpgrade = dict.get("rhysticUpgrade", false)
	pass

func returnDictionary () -> Dictionary:
	var dict = {
		"money_per_click": money_per_click,
		"money_per_second": money_per_second,
		"money_multiplier": money_multiplier,
		"combo_crit_chance_multiplier": combo_crit_chance_multiplier,
		"combo_crit_multi_multiplier": combo_crit_multi_multiplier,
		"combo_wait_time": combo_wait_time,
		"crit_chance": crit_chance,
		"crit_multi": crit_multi,
		"doubler": doubler,
		"rhysticUpgrade": rhysticUpgrade
	}
	
	return dict

@onready var combo_timer = Timer.new();
signal update_all(delta)
func _process(delta: float) -> void:
	if self.get_child_count() > 0:
		emit_signal("update_all", delta)

func _ready() -> void:
	
	#UI declerations
	size = Vector2(600, 220);
	position = Vector2((get_viewport_rect().size.x / 2) - 300, (get_viewport_rect().size.y / 2) - 240);
	
	#money per second timer 
	var money_timer = Timer.new();
	money_timer.wait_time = 1.0;
	money_timer.one_shot = false;
	money_timer.connect("timeout", Callable(self, "_money_timer_timeout"));
	add_child(money_timer);
	money_timer.start();
	
	#combo timer
	combo_timer.wait_time = combo_wait_time;
	combo_timer.one_shot = false;
	combo_timer.connect("timeout", Callable(self, "_comboTimer_timeout"))
	add_child(combo_timer)
	#sets text on open
	updateText();
	
	pass




#money per second timer call
func _money_timer_timeout() -> void:
	Player.money += money_per_second;
	updateText();
	$"../CanvasLayer/level_Label".setText()
	pass

#combo timer call
func _comboTimer_timeout() -> void:
	combo = 0;
	combo_timer.stop();
	pass

func _pressed() -> void:
	if rhysticUpgrade && randf() >= 0.8:
		$"../Pack_Clicker"._pressed()
	combo_timer.stop();
	if randf_range(0, 100) <= crit_chance * 1.0 + (float(combo) / 100.0 * combo_crit_chance_multiplier):
		Player.money += (money_per_click * 1.0 + (float(combo) / 1000.0)) * (money_multiplier * crit_multi * 1.0 + (float(combo / 10000.0 * combo_crit_multi_multiplier)));
		var popup = money_popup.new()
		add_child(popup)
		popup.init((money_per_click * (1 + float(combo) / 1000)) * (money_multiplier) * (crit_multi), true, true)
	else:
		Player.money += (money_per_click * (1 + float(combo) / 1000)) * money_multiplier;
		var popup = money_popup.new()  # money_popup is the script/class
		add_child(popup)
		popup.init((money_per_click * (1 + float(combo)/1000)) * money_multiplier, false, true)
		print("mpc:", money_per_click, " combo:", combo, " mm:", money_multiplier, " cm:", crit_multi * 1.0 + (float(combo / 10000.0 * combo_crit_multi_multiplier)), " cc:", crit_chance * 1.0 + (float(combo) / 100.0 * combo_crit_chance_multiplier))
		
	if combo < max_combo:
		combo += 1;
	else:
		combo = max_combo
	combo_timer.start();
	updateText();
	$"../CanvasLayer/level_Label".setText()
	pass

func updateText() -> void:
	set_text("$" + str("%1.2f" % Player.money) + "\n" + (str(combo/10) + "%"))
	pass
