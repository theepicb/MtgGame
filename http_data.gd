extends Node2D

@warning_ignore("unused_signal")
signal Finished 
func _ready() -> void:
	print(get_children())
	

func deleteChildren():
	for child in get_children():
		child.queue_free()
