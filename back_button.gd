extends Control

func _ready() -> void:
	visible = false;
	size = Vector2(160, 80);
	
	pass

func _pressed():
	for x in Player.cardsToShow:
		x.visible = false;
		pass
	$"../Open_Packs_Screen".showUI()
	visible = false;
	for child in Player.cardsToDelete:
		if is_instance_valid(child):
			child.queue_free()
	Player.cardsToDelete.clear()
	Player.cardsToShow.clear();
	pass

func draw() -> void:
	position = Vector2((get_viewport_rect().size.x / 2) - 300, 500);
	visible = true;
	print("drawing Back button")
	pass
