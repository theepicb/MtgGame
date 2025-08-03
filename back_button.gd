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
	Player.cardsToShow.clear();
	pass

func draw() -> void:
	position = Vector2((get_viewport_rect().size.x / 2) - 300, 500);
	visible = true;
	print("drawing Back button")
	pass
