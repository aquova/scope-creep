extends Node2D

@onready var grid = $Grid
@onready var sprite = $Sprite
@onready var animation = $Sprite/AnimationPlayer
@onready var hp_bar = $Sprite/HpBar
@onready var fire_bar = $Sprite/FireBar
@onready var weapon = $WeaponTimer
@onready var movement_timer = $MovementTimer
@onready var respawn_timer = $RespawnTimer
@onready var damage_label = preload("res://scenes/vanishing_text.tscn")

const TWEEN_DELAY: float = 0.1
const MOVEMENT_DELAY = 2.0

signal fire_weapon(damage: int)
signal enemy_killed

var enemy_pos: Vector2
var can_move_enemy: bool
var dead: bool
var highlight_pos = Vector2(2, 2)

var weapon_delay = 5.0
var hp: int
var max_hp: int = 100

func start() -> void:
	spawn()
	grid.highlight_tiles([highlight_pos])
	
func spawn() -> void:
	dead = false
	sprite.visible = true
	hp_bar.visible = false
	enemy_pos = Vector2(randi_range(0, grid.GRID_DIM.x - 1), randi_range(0, grid.GRID_DIM.y - 1))
	can_move_enemy = true
	position_sprite(false)
	animation.play("idle")
	hp = max_hp
	weapon.start(weapon_delay)
	movement_timer.start(MOVEMENT_DELAY)
	fire_bar.start(weapon_delay)
	
func die() -> void:
	# TODO: Explosion
	enemy_killed.emit()
	sprite.visible = false
	dead = true
	respawn_timer.start()
	
func hit(damage: int) -> void:
	if highlight_pos != enemy_pos or dead:
		return
	hp -= damage
	var label = damage_label.instantiate()
	sprite.add_child(label)
	label.start(str(damage))
	hp_bar.visible = true
	hp_bar.value = hp
	if hp <= 0:
		die()
	
func move_highlight(delta: Vector2) -> void:
	var hx = highlight_pos.x + delta.x
	var hy = highlight_pos.y + delta.y
	var new_highlight = Vector2(hx, hy)

	if grid.is_in_bounds(new_highlight):
		highlight_pos = new_highlight
		grid.highlight_tiles([highlight_pos])
	
func move_enemy() -> void:
	const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var new_pos: Vector2
	if highlight_pos == enemy_pos:
		new_pos = enemy_pos + DIRECTIONS.pick_random()
	else:
		var rel = enemy_pos - highlight_pos
		rel = rel.normalized().round()
		# If not normalized, then diagonal. Don't allow diagonal movement
		if not rel.is_normalized():
			rel.y = 0
		new_pos = enemy_pos + rel
		
	if grid.is_in_bounds(new_pos):
		enemy_pos = new_pos
		position_sprite(true)

func position_sprite(tween: bool) -> void:
	var new_pos = grid.get_sprite_xy(enemy_pos)
	if tween:
		var move_lambda = func(): can_move_enemy = true
		var position_tween = create_tween()
		position_tween.tween_property(sprite, "position", new_pos, TWEEN_DELAY)
		position_tween.set_trans(Tween.TRANS_EXPO)
		position_tween.tween_callback(move_lambda)
		can_move_enemy = false
	else:
		sprite.position = new_pos

func _on_weapon_timeout() -> void:
	if dead: return
	animation.play("attack")
	animation.queue("idle")
	fire_weapon.emit(10)
	fire_bar.start(weapon_delay)

func _on_movement_timeout() -> void:
	if dead: return
	move_enemy()

func _on_respawn_timer_timeout() -> void:
	spawn()
