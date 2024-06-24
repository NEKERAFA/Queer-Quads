extends TileBlock
class_name TileLineVertical


@export var color_up: Color = Color.GRAY:
	get:
		return color_up
	set(value):
		color_up = value
		if _tile_up != null:
			_set_color_up(value)

@export var color_down: Color = Color.GRAY:
	get:
		return color_down
	set(value):
		color_down = value
		if _tile_down != null:
			_set_color_down(value)


@onready var _tile_up: RigidBody2D = $TileUp
@onready var _tile_down: RigidBody2D = $TileDown


func _init() -> void:
	super(Type.VERTICAL, 1, 2)


func _ready() -> void:
	_set_color_up(color_up)
	_set_color_down(color_down)


func _set_color_up(color: Color) -> void:
	_tile_up.tile_color = color


func _set_color_down(color: Color) -> void:
	_tile_down.tile_color = color


func enable_gravity():
	_tile_up.enable_gravity()
	_tile_down.enable_gravity()


func test_move() -> bool:
	return (
		_tile_up.test_move(_tile_up.transform, Vector2(0, 0))
		and _tile_down.test_move(_tile_down.transform, Vector2(0, 0))
	)


func _on_destroy_tile_up(position: Vector2) -> void:
	destroy.emit(position)


func _on_destroy_tile_down(position: Vector2) -> void:
	destroy.emit(position)
