extends Node


const COLUMNS := 12
const ROWS := 8


@export var elements: Node2D


var _data = []


func _ready() -> void:
	for column in range(COLUMNS):
		_data.append([])
		for row in range(ROWS):
			_data[column].append(null)


func _physics_process(_delta: float) -> void:
	for column in range(COLUMNS):
		for row in range(ROWS):
			_data[column][row] = null

	if elements != null:
		var tiles = get_tree().get_nodes_in_group("tiles")
		for tile: Tile in tiles:
			if tile.sleeping:
				var tile_cell = floor((tile.global_position - elements.position) / 96)
				_data[tile_cell.x][tile_cell.y] = tile


func is_in_bounds(column: int, row: int) -> bool:
	return column >= 0 and column < COLUMNS and row >= 0 and row < ROWS


func is_tile(column: int, row: int) -> bool:
	return is_in_bounds(column, row) and _data[column][row] != null


func get_tile(column: int, row: int) -> Tile:
	return (_data[column][row] as Tile) if is_in_bounds(column, row) and is_tile(column, row) else null
