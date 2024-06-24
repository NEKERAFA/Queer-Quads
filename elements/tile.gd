extends RigidBody2D
class_name Tile


signal destroy(position: Vector2)


@export var tile_color: Color = Color.GRAY:
	get:
		return tile_color
	set(value):
		tile_color = value
		if _tile_sprite_color != null:
			_set_color(tile_color)


@onready var _tile_sprite_color: ColorRect = $TileSprite/Color/ColorRect
@onready var _tile_shape: CollisionShape2D = $TileShape
@onready var _anim_player: AnimationPlayer = $AnimationPlayer


var destroyed: bool = false:
	get = is_destroyed, set = set_destroyed


func enable_gravity() -> void:
	add_to_group("tiles")
	freeze = false
	_tile_shape.set_deferred("disabled", false)


func _ready() -> void:
	_set_color(tile_color)


func _set_color(color: Color) -> void:
	_tile_sprite_color.color = tile_color


func is_destroyed() -> bool:
	return destroyed


func set_destroyed(value: bool) -> void:
	destroyed = value
	if value:
		_anim_player.play("destroy")


func _emit_destroy() -> void:
	_tile_shape.set_deferred("disabled", true)

	var neighbours = get_colliding_bodies()
	for node in neighbours:
		if node is Tile:
			(node as Tile).sleeping = false

	destroy.emit(global_position)

	queue_free()
