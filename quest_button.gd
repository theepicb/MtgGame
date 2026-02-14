extends Button

var unlocked = false
func _ready() -> void:
	position = Vector2(240, 5)
	text = "Quests"
	visible = false

func saveDict () -> Dictionary:
	var dict = {
		"unlocked": unlocked
	}
	return dict

func loadDict (dictionary: Dictionary):
	unlocked = dictionary.get("unlocked", false)
	
	
	if unlocked == true:
		self.visible = true
	else:
		self.visible = false
