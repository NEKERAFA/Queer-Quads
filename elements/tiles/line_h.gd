extends TileBlock
class_name TileLineHorizontal


@export var color_left: Color = Color.GRAY:
	get:
		return color_left
	set(value):
		color_left = value
		if _tile_left != null:
			_set_color_left(value)

@export var color_right: Color = Color.GRAY:
	get:
		return color_right
	set(value):
		color_right = value
		if _tile_right != null:
			_set_color_right(value)


@onready var _tile_left: RigidBody2D = $TileLeft
@onready var _tile_right: RigidBody2D = $TileRight


func _init() -> void:
	super(Type.HORIZONTAL, 2, 1)


func _ready() -> void:
	_set_color_right(color_left)
	_set_color_left(color_right)


func _set_color_right(color: Color) -> void:
	_tile_left.tile_color = color


func _set_color_left(color: Color) -> void:
	_tile_right.tile_color = color


func enable_gravity():
	_tile_left.enable_gravity()
	_tile_right.enable_gravity()


func test_move() -> bool:
	return (
		_tile_left.test_move(_tile_left.transform, Vector2(0, 0))
		and _tile_right.test_move(_tile_right.transform, Vector2(0, 0))
	)


func _on_destroy_tile_left(position: Vector2) -> void:
	destroy.emit(position)


func _on_destroy_tile_right(position: Vector2) -> void:
	destroy.emit(position)
