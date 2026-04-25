extends Node2D

var set_name = "spg"

func _ready() -> void:
	Lib.ensure_directory_exists("user://Cards/spg")

func getSpecialGuest (foil, list, counter, isLast):
	Lib.grabCard(set_name, list, foil, Lib.getPosition(counter).x, Lib.getPosition(counter).y, isLast)
