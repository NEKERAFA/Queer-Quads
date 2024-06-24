extends Node2D
class_name TileBlock


signal destroy(position: Vector2)


enum Type { NONE = -1, VERTICAL = 0, HORIZONTAL, T }


var type: Type
var width: int
var height: int


func _init(type: Type = Type.NONE, width: int = 0, height: int = 0) -> void:
	self.type = type
	self.width = width
	self.height = height


func enable_gravity():
	pass


func test_move() -> bool:
	return false
