extends Node2D

@onready var player = $Camera2D/Player
@onready var enemy = $Camera2D/Enemy
@onready var camera = $Camera2D
@onready var hud = $HUD
@onready var level_label = $HUD/LevelLabel
@onready var gameover_label = $HUD/GameOverLabel

enum STATE {
	MENU,
	PLAYING,
	GAMEOVER,
}

const PARALLAX_SPEED: float = 1.5
const TRANSITION_TIME: float = 5.0
const XP_PER_KILL = 20
const DELTA_XP_PER_LEVEL = 10

var state: STATE = STATE.PLAYING
var xp: int = 0
var level: int = 1
var xp_per_level = 30

func _ready() -> void:
	player.start()
	enemy.start()

func _process(_delta: float) -> void:
	move_parallax()
	match self.state:
		STATE.MENU | STATE.GAMEOVER:
			pass
		STATE.PLAYING:
			check_input()
	
func check_input() -> void:
	if Input.is_action_just_pressed("input_up"):
		player.move_player(Vector2.UP)
	elif Input.is_action_just_pressed("input_down"):
		player.move_player(Vector2.DOWN)
	elif Input.is_action_just_pressed("input_left"):
		player.move_player(Vector2.LEFT)
	elif Input.is_action_just_pressed("input_right"):
		player.move_player(Vector2.RIGHT)
		
	if Input.is_action_just_pressed("weapon_up"):
		enemy.move_highlight(Vector2.UP)
	elif Input.is_action_just_pressed("weapon_down"):
		enemy.move_highlight(Vector2.DOWN)
	elif Input.is_action_just_pressed("weapon_left"):
		enemy.move_highlight(Vector2.LEFT)
	elif Input.is_action_just_pressed("weapon_right"):
		enemy.move_highlight(Vector2.RIGHT)
		
func move_parallax() -> void:
	camera.move_local_x(PARALLAX_SPEED)

func _on_player_fire_weapon(damage: int) -> void:
	enemy.hit(damage)

func _on_enemy_enemy_killed() -> void:
	xp += XP_PER_KILL
	if xp >= xp_per_level:
		level += 1
		xp %= xp_per_level
		xp_per_level += DELTA_XP_PER_LEVEL
		hud.set_max_xp(xp_per_level)
	player.award_xp(XP_PER_KILL)
	level_label.set_text("LEVEL: %d" % level)
	hud.set_xp(xp)

func _on_enemy_fire_weapon(damage: int) -> void:
	player.hit(damage)

func _on_player_game_over() -> void:
	gameover_label.visible = true
