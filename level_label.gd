extends Label
func setText ():
	text = "Level " + str(Player.level) +  "\n" + str(Player.xpToLevelUp[Player.level] - Player.xp) + " xp to go\n" + "$" +  str("%1.2f" % Player.money) + "\ntix:" + str(Player.tix)

func _ready() -> void:
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.DIM_GRAY
	add_theme_stylebox_override("normal", new_sb)
	size = Vector2(180, 120)
	position = Vector2(5, get_viewport_rect().size.y - 125)
	setText()
	get_window().size_changed.connect(_on_window_size_changed)

func _on_window_size_changed():
	position = Vector2(5, get_viewport_rect().size.y - 125)
	
