extends Node2D
var path = "user://Cards/";

func _ready() -> void:
	ensure_directory_exists(path)
	pass
	
func ensure_directory_exists(dir_path: String) -> void:
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(dir_path):
		var err = dir.make_dir(dir_path)
		if err == OK:
			print("Directory created:", dir_path)
		else:
			print("Failed to create directory:", err)
	else:
		print("Directory already exists:", dir_path)
		
func getPosition(x) -> Vector2:
	var pos = Vector2(100 + ((x % 10) * 200), 200 + (290 *(floor(x/ 10))))
	return pos

func getLuck(pack_luck: float = 1) -> int:
	var num = randi_range(0, 100)
	num = num * (Player.luck * pack_luck)
	return num
	
func drawBackButton ():
	$"../CanvasLayer/Back_Button".draw()
