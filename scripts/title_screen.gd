extends Node2D

@onready var camera = $Camera2D

# Must match value in game.gd
# TODO: Improve that, maybe
const PARALLAX_SPEED: float = 1.5

func _process(_delta) -> void:
	camera.move_local_x(PARALLAX_SPEED)

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
