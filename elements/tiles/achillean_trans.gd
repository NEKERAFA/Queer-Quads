extends TileBlock
class_name AchilleanTransBlock


func _init() -> void:
	super(Type.T, 3, 3)


func enable_gravity():
	for tile: Tile in get_children():
		tile.enable_gravity()


func test_move() -> bool:
	return get_children().all(func(tile: Tile): return tile.test_move(tile.transform, Vector2(0, 0)))


func _on_tile_destroy(position: Vector2) -> void:
	destroy.emit(position)
