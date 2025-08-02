extends Button

var completion = 0;

var complete = false;

var completionPerClick = 100;
var autoCompletion = 0;
var maxCompletion = 100;

var unlockedCommonPacks = [];
var unlockedUncommonPacks = [];
var unlockedRarePacks = [];

func _ready() -> void:
	size = Vector2(600, 220)
	position = Vector2((get_viewport_rect().size.x / 2) - 300, (get_viewport_rect().size.y / 2) );
	text = "Click to get packs! \n" + str(completion) + "/100%";
	pass

func _pressed() -> void:
	if completion + completionPerClick >= maxCompletion:
		completion = maxCompletion;
		pass
	else:
		completion += completionPerClick;
		pass
	if completion >= 100:
		complete = true;
		pass
	
	if complete && get_child_count() == 0:
		var claimButton = Button.new();
		add_child(claimButton)
		claimButton.pressed.connect(claimButtonPressed);
		claimButton.size = Vector2(180, 60);
		claimButton.position = Vector2((get_viewport_rect().size.x / 2) - 360, (get_viewport_rect().size.y / 2) - 100);
		pass
	updateText();
	pass

func updateText():
	text = "Click to get packs! \n" + str(completion) + "/100%";
	pass
	
func claimButtonPressed():
	print("worked");
	completion = completion - 100;
	if completion < 100:
		deleteChildren()
		
	getCommonPack();
	updateText()
	pass
	
func getRarePack():
	if unlockedRarePacks.is_empty():
		getUncommonPack();
		pass
	else:
		var temp = unlockedRarePacks.pick_random();
		for pack in $"../Pack_Screen".packs:
			if pack.id == temp:
				pack.owned += 1;
				pass
			pass
		pass
	pass
	
func getUncommonPack():
	if unlockedCommonPacks.is_empty():
		getCommonPack();
		pass
	else:
		var temp = unlockedUncommonPacks.pick_random();
		for pack in $"../Pack_Screen".packs:
			if pack.id == temp:
				pack.owned += 1;
			pass
	pass
	
func getCommonPack():
	var temp = unlockedCommonPacks.pick_random();
	for pack in $"../Pack_Screen".packs:
		if pack.id == temp:
			pack.owned += 1;
			print(pack.id + ": " + str(pack.owned));
		pass
	pass

func deleteChildren ():
	for child in get_children():
		child.queue_free()
