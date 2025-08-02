extends Button
var money_per_click = 0.01;
var money_per_second = 0;
var money_multiplier = 1;

var combo_wait_time = 1;
var combo = 0;

@onready var combo_timer = Timer.new();

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
	$"../Player".money += money_per_second;
	updateText();
	pass
#combo timer call
func _comboTimer_timeout() -> void:
	combo = 0;
	combo_timer.stop();
	pass

func _pressed() -> void:
	combo_timer.stop();
	$"../Player".money += (money_per_click * (1 + float(combo) / 1000)) * money_multiplier;
	combo += 1;
	combo_timer.start();
	updateText();
	
	pass

func updateText() -> void:
	set_text("$" + str("%1.2f" % $"../Player".money) + "\n" + (str(combo/10) + "%"))
	pass
