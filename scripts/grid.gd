extends Control

@onready var tile_scene = preload("res://scenes/grid_tile.tscn")
@onready var tiles = $tiles

const GRID_DIM = Vector2(5, 5)
const MARGIN = Vector2(-25, -20)
const PADDING = 10

var board = []

func _ready() -> void:
	for y in range(0, GRID_DIM.y):
		var row = []
		for x in range(0, GRID_DIM.x):
			var tile = tile_scene.instantiate()
			tile.position = Vector2(x * (tile.size.x + PADDING), y * (tile.size.y + PADDING))
			tiles.add_child(tile)
			row.append(tile)
		board.append(row)

func get_sprite_xy(pos: Vector2) -> Vector2:
	var tile = board[pos.y][pos.x]
	return Vector2(tile.position.x + MARGIN.x, tile.position.y + MARGIN.y)
	
func is_in_bounds(xy: Vector2) -> bool:
	return xy.x >= 0 and xy.x < GRID_DIM.x and xy.y >= 0 and xy.y < GRID_DIM.y

func highlight_tiles(pos: Array) -> void:
	for y in range(0, GRID_DIM.y):
		for x in range(0, GRID_DIM.x):
			var highlight = Vector2(x, y) in pos
			board[y][x].set_highlight(highlight)
