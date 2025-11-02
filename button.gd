class_name UpgradeNode
extends Button

var id: String
var pos: Vector2
var on_click_func: Callable
var children: Array
var ID: String

func _init(_pos: Vector2 = Vector2(0, 0), _children: Array = [], _ID: String = "") -> void:
	if _pos.x == 0:
		self.queue_free()
	self.pos = _pos
	self.children = _children
	self.ID = _ID
	self.size = Vector2(200, 65)
	pass

func _ready():
	global_position = pos
	self.visible = false;
	if on_click_func:
		connect("pressed", on_click_func);

func _show ():
	self.visible = true

func getPosition ():
	return self.pos
