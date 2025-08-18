extends Node2D

signal Finished 
func _ready() -> void:
	print(get_children())
	

func deleteChildren():
	for child in get_children():
		child.queue_free()
