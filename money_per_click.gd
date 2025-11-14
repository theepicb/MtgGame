extends Label
class_name money_popup
var direction := Vector2()
var fade_speed := 0.6
var fade_amount := 0.0
var speedMulti = 20
func init(amount: float, critical: bool, money: bool) -> void:
	if money:
		text = "$" + str("%.2f" % amount)
	else:
		text =str("%.1f" % amount) + "%"
	if critical:
		add_theme_color_override("font_color", Color.ORANGE_RED)
	else:
		add_theme_color_override("font_color", Color.WHITE)

	# Initialize per-instance variables
	
	if critical:
		speedMulti = 45
	direction = Vector2(randf_range(-5, 5), -2)
	fade_speed = randf_range(0.5, 0.8)
	fade_amount = 0.0

	# Position relative to parent (a Control node)
	position = get_parent().get_local_mouse_position()
	visible = true

func _process(delta: float) -> void:
	fade_amount += delta
	modulate.a = clamp(1.0 - fade_amount / fade_speed, 0.0, 1.0)

	position += direction * delta * speedMulti

	if modulate.a <= 0.0:
		queue_free()
