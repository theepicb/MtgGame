extends Label
func setText ():
	text = "Level " + str(Player.level) +  "\n" + str(Player.xpToLevelUp[Player.level] - Player.xp) + " xp to go"

func _ready() -> void:
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = Color.DIM_GRAY
	add_theme_stylebox_override("normal", new_sb)
	size = Vector2(180, 60)
	position = Vector2(5, get_viewport_rect().size.y - 90)
	setText()
	
