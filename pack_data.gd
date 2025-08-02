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
