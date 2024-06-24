extends Object
class_name TileColors


const WHITE := Color(0.9, 0.9, 0.9)
const YELLOW := Color(1, 0.957, 0.2)
const PURPLE := Color(0.608, 0.349, 0.816)
const BLACK := Color(0.176, 0.176, 0.176)


static func get_color(colors: int = 2) -> Color:
	if colors == 2:
		match randi_range(0, 1):
			0:
				return YELLOW
			1:
				return PURPLE
	elif colors == 4:
		match randi_range(0, 3):
			0:
				return YELLOW
			1:
				return PURPLE
			2:
				return BLACK

	return WHITE
