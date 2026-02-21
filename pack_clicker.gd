extends Button

var completion = 0;

var complete = false;
var complete_Button = false

var completionPerClick = 1;
var autoCompletion = 0;
var maxCompletion = 100;

var unlockedCommonPacks = [];
var unlockedUncommonPacks = [];
var unlockedRarePacks = [];
var unlockedEpicPacks = [];
var unlockedLegendaryPacks = [];

var chances = [80, 20, 1, 0, 0]
var chanceLuck = 0

func returnDictionary()->Dictionary:
	var dict = {
		"completion": completion,
		"completionPerClick": completionPerClick,
		"autoCompletion": autoCompletion,
		"maxCompletion": maxCompletion,
		"chances": chances,
		"chanceLuck": chanceLuck,
		"unlockedPacks": {"common": unlockedCommonPacks, "uncommon": unlockedUncommonPacks, "rare": unlockedRarePacks, "epic": unlockedEpicPacks, "legendary": unlockedLegendaryPacks,}
	}
	print(dict)
	return dict

func setDictionary(dict: Dictionary):
	print("dictionary: ", dict)
	completion = dict.get("completion", 0)
	completionPerClick = dict.get("completionPerClick", 1)
	autoCompletion = dict.get("autoCompletion", 0)
	maxCompletion = dict.get("maxCompletion", 100)
	chanceLuck = dict.get("chanceLuck", 0)
	var packs = dict.get("unlockedPacks", {})
	unlockedCommonPacks = packs.get("common", [])
	unlockedUncommonPacks = packs.get("uncommon", [])
	unlockedRarePacks = packs.get("rare", [])
	unlockedEpicPacks = packs.get("epic", [])
	unlockedLegendaryPacks = packs.get("legendary", [])
	if completion >= 100:
		complete_Button = true
		createClaimButton()
	updateText()

func _ready() -> void:
	size = Vector2(600, 220)
	position = Vector2((get_viewport_rect().size.x / 2) - 300, (get_viewport_rect().size.y / 2) );
	text = "Click to get packs! \n" + str(completion) + "/" + str(maxCompletion) + "%";
	
	pass

func _pressed() -> void:
	if completion + completionPerClick >= maxCompletion:
		completion = maxCompletion;
		pass
	else:
		completion += completionPerClick;
		var popup = money_popup.new()
		add_child(popup)
		popup.init(completionPerClick, false, false)
		pass
	if completion >= 100:
		complete = true;
	else: 
		complete = false
		pass
	
	if complete && !complete_Button:
		createClaimButton()
	updateText();
	pass

func createClaimButton():
	complete_Button = true
	var claimButton = Button.new();
	add_child(claimButton)
	claimButton.text = "claim pack!"
	claimButton.pressed.connect(claimButtonPressed);
	claimButton.size = Vector2(180, 60);
	claimButton.position = Vector2((get_viewport_rect().size.x / 2) - 360, (get_viewport_rect().size.y / 2) - 100);

func updateText():
	text = "Click to get packs! \n" + str(completion) + "/100%";
	pass
	
func claimButtonPressed():
	print("worked");
	completion = completion - 100;
	if completion < 100:
		deleteChildren()
		complete_Button = false
	
	var outCome = getRarityByWeight(["common", "uncommon", "rare", "legendary"], returnChances())
	
	print(returnChances(), "com: ", unlockedCommonPacks)
	
	match outCome:
		"common":
			getCommonPack();
			pass
		"uncommon":
			getUncommonPack()
			pass
		"rare":
			getRarePack()
			pass
		"legendary":
			getLegendaryPack()
			pass
			
	updateText()
	pass

func returnChances() -> Array:
	var chance = [80, 20 + (chanceLuck / 2), 1 + (chanceLuck / 4), -2 + (chanceLuck / 2), -10 + (chanceLuck / 1.5)]
	return chance

func getLegendaryPack():
	if unlockedLegendaryPacks.is_empty():
		getEpicPack();
		pass
	else:
		var temp = unlockedLegendaryPacks.pick_random();
		for pack in $"../Pack_Screen".packs:
			if pack.id == temp:
				pack.owned += 1;
				pass
			pass
		pass
	pass

func getEpicPack():
	if unlockedLegendaryPacks.is_empty():
		getUncommonPack();
		pass
	else:
		var temp = unlockedEpicPacks.pick_random();
		for pack in $"../Pack_Screen".packs:
			if pack.id == temp:
				pack.owned += 1;
				pass
			pass
		pass
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
	if unlockedUncommonPacks.is_empty():
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

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]
