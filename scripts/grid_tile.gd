extends ColorRect

@onready var shader_material = preload("res://materials/tile.tres")

var highlight = false

func is_highlight() -> bool:
	return highlight

func set_highlight(hl: bool) -> void:
	highlight = hl
	if highlight:
		set_material(shader_material)
	else:
		set_material(null)
