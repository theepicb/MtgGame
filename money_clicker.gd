extends Button


var money_per_click = 0.01;
var money_per_second = 0;
var money_multiplier = 1;

var combo_wait_time = 1;
var combo = 0;

var crit_chance = 0
var crit_multi = 2

var doubler = 0;

var rhysticUpgrade = false

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
	pass

#combo timer call
func _comboTimer_timeout() -> void:
	combo = 0;
	combo_timer.stop();
	pass

func _pressed() -> void:
	if rhysticUpgrade && $"../Pack_Data".getLuck() >= 80:
		$"../Pack_Clicker"._pressed()
	combo_timer.stop();
	if randf_range(0, 100) <= crit_chance:
		Player.money += (money_per_click * (1 + float(combo) / 1000)) * (money_multiplier * crit_multi);
		var popup = money_popup.new()
		add_child(popup)
		popup.init((money_per_click * (1 + float(combo) / 1000)) * (money_multiplier * crit_multi), true, true)
		
	else:
		Player.money += (money_per_click * (1 + float(combo) / 1000)) * money_multiplier;
		var popup = money_popup.new()  # money_popup is the script/class
		add_child(popup)
		popup.init((money_per_click * (1 + float(combo)/1000)) * money_multiplier, false, true)
	combo += 1;
	combo_timer.start();
	updateText();
	
	pass

func updateText() -> void:
	set_text("$" + str("%1.2f" % Player.money) + "\n" + (str(combo/10) + "%"))
	pass
