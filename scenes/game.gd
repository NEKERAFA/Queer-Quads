extends Node


const LINE_VERTICAL = preload("res://elements/tiles/line_v.tscn")
const LINE_HORIZONTAL = preload("res://elements/tiles/line_h.tscn")
const ACHILLEAN_TRANS = preload("res://elements/tiles/achillean_trans.tscn")
const POINT = preload("res://ui/point.tscn")


@onready var _elements_node = $Elements
@onready var _next_position = $NextPosition
@onready var _game_state = $GameState
@onready var _move_player = $MoveAudioPlayer
@onready var _destroy_player = $DestroyAudioPlayer
@onready var _points_position = $PointsPosition
@onready var _points_lbl = $UI/Points
@onready var _gameover_ui = $UI/GameoverContainer
@onready var _any_key_ui = $UI/GameoverContainer/AnyKeyLabel
@onready var _timer = $Timer


var _gameover = false
var _points = 0
var _current_block: TileBlock = null
var _next_block: TileBlock = null


func _ready() -> void:
	_current_block = _create_block()
	if _current_block != null:
		_current_block.destroy.connect(_on_destroy_tile)
		_elements_node.add_child(_current_block)
		_current_block.position.x = 96 * (6 - floor(_current_block.width / 2))

	_next_block = _create_block()
	if _next_block != null:
		add_child(_next_block)
		_next_block.position = $NextPosition.position + Vector2(- _next_block.width * 96 / 2, 0)


func _input(event: InputEvent) -> void:
	if not _gameover:
		if event.is_action_pressed("ui_left"):
			var old_value = _current_block.position.x
			_current_block.position.x = max(0, _current_block.position.x - 96)

			if old_value != _current_block.position.x:
				_move_player.play()

		elif event.is_action_pressed("ui_right"):
			var old_value = _current_block.position.x
			_current_block.position.x = min(96 * (12 - _current_block.width), _current_block.position.x + 96)

			if old_value != _current_block.position.x:
				_move_player.play()

		elif event.is_action_pressed("ui_accept"):
			_current_block.enable_gravity()

			_current_block = _next_block
			_current_block.destroy.connect(_on_destroy_tile)
			remove_child(_current_block)
			_elements_node.add_child(_current_block)
			_current_block.position.x = 96 * (6 - floor(_current_block.width / 2))
			_current_block.position.y = 0

			_create_next_block()
	elif _any_key_ui.visible:
		get_tree().reload_current_scene()


func _process(delta: float) -> void:
	for column in range(0, 12):
		for row in range(0, 8):
			if not _game_state.is_tile(column, row):
				continue

			var tile = _game_state.get_tile(column, row)
			if tile.destroyed:
				continue

			var top_left = _game_state.get_tile(column - 1, row - 1)
			var top_middle = _game_state.get_tile(column, row - 1)
			var top_right = _game_state.get_tile(column + 1, row - 1)
			var middle_left = _game_state.get_tile(column - 1, row)
			var middle_right = _game_state.get_tile(column + 1, row)
			var bottom_left = _game_state.get_tile(column - 1, row + 1)
			var bottom_middle = _game_state.get_tile(column, row + 1)
			var bottom_right = _game_state.get_tile(column + 1, row + 1)

			if (
					top_left != null and top_left.tile_color == tile.tile_color
					and top_middle != null and top_middle.tile_color == tile.tile_color
					and middle_left != null and middle_left.tile_color == tile.tile_color
			) or (
					top_middle != null and top_middle.tile_color == tile.tile_color
					and top_right != null and top_right.tile_color == tile.tile_color
					and middle_right != null and middle_right.tile_color == tile.tile_color
			) or (
					middle_left != null and middle_left.tile_color == tile.tile_color
					and bottom_left != null and bottom_left.tile_color == tile.tile_color
					and bottom_middle != null and bottom_middle.tile_color == tile.tile_color
			) or (
					middle_right != null and middle_right.tile_color == tile.tile_color
					and bottom_middle != null and bottom_middle.tile_color == tile.tile_color
					and bottom_right != null and bottom_right.tile_color == tile.tile_color
			):
				tile.destroyed = true


func _create_next_block() -> void:
	_next_block = _create_block()
	if _next_block != null:
		add_child(_next_block)
		_next_block.position = $NextPosition.position + Vector2(- _next_block.width * 96 / 2, 0)


func _create_block() -> TileBlock:
	var node = null

	if _points < 40:
		match randi_range(0, 1):
			0:
				node = LINE_VERTICAL.instantiate() as TileLineVertical
				node.color_up = TileColors.get_color(2 if _points < 20 else 4)
				node.color_down = TileColors.get_color(2 if _points < 20 else 4)
			1:
				node = LINE_HORIZONTAL.instantiate() as TileLineHorizontal
				node.color_left = TileColors.get_color(2 if _points < 20 else 4)
				node.color_right = TileColors.get_color(2 if _points < 20 else 4)
	else:
		match randi_range(0, 2):
			0:
				node = LINE_VERTICAL.instantiate() as TileLineVertical
				node.color_up = TileColors.get_color(2 if _points < 20 else 4)
				node.color_down = TileColors.get_color(2 if _points < 20 else 4)
			1:
				node = LINE_HORIZONTAL.instantiate() as TileLineHorizontal
				node.color_left = TileColors.get_color(2 if _points < 20 else 4)
				node.color_right = TileColors.get_color(2 if _points < 20 else 4)
			2:
				node = ACHILLEAN_TRANS.instantiate()

	return node


func _on_gameover_area_body_entered(body: Node2D) -> void:
	_gameover = true
	_gameover_ui.show()
	_timer.start()


func _on_destroy_tile(position: Vector2) -> void:
	if not _destroy_player.playing:
		_destroy_player.play()

	var point_label = POINT.instantiate()
	point_label.position = position
	add_child(point_label)

	var tween = get_tree().create_tween()
	tween.tween_property(point_label, "position", _points_position.position - point_label.size / 2, 0.5)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(point_label.queue_free)
	tween.set_parallel()
	tween.tween_callback(_add_points)


func _add_points():
	_points += 1
	_points_lbl.text = str(_points)


func _on_timer_timeout() -> void:
	_any_key_ui.show()
