extends Node2D

@onready var grid = $Grid
@onready var sprite = $Sprite
@onready var animation = $Sprite/AnimationPlayer
@onready var weapon = $WeaponTimer
@onready var hp_bar = $Sprite/HpBar
@onready var fire_bar = $Sprite/FireBar
@onready var hurtbox_timer = $MoveHurtboxTimer
@onready var floating_label = preload("res://scenes/vanishing_text.tscn")

const TWEEN_DELAY: float = 0.1
const HURTBOX_DELAY = 1.5

var dead = false
var player_pos: Vector2 = Vector2(2, 2)
var can_move_player: bool = true
var hurtbox_pos: Vector2 = Vector2(2, 2)

var weapon_delay: float = 3.0 # TODO: Increase at some point

var hp: int = 100
var max_hp: int = 100

signal fire_weapon(damage: int)
signal game_over()

func start() -> void:
	position_sprite(false)
	animation.play("idle")
	grid.highlight_tiles([hurtbox_pos])
	sprite.visible = true
	weapon.start(weapon_delay)
	fire_bar.start(weapon_delay)
	hurtbox_timer.start(HURTBOX_DELAY)
	
func award_xp(delta: int) -> void:
	var label = floating_label.instantiate()
	sprite.add_child(label)
	label.start("+%d xp" % delta)
	
func hit(delta: int) -> void:
	if player_pos != hurtbox_pos:
		return
	hp -= delta
	var label = floating_label.instantiate()
	sprite.add_child(label)
	label.start(str(delta), Color.BLACK)
	hp_bar.visible = true
	hp_bar.value = hp
	if hp <= 0:
		sprite.visible = false
		game_over.emit()

func move_player(delta: Vector2) -> void:
	if not can_move_player:
		return
	var nx = player_pos.x + delta.x
	var ny = player_pos.y + delta.y
	var new_pos = Vector2(nx, ny)
	
	if grid.is_in_bounds(new_pos):
		player_pos = new_pos
		position_sprite(true)
	
func move_hurtbox() -> void:
	if hurtbox_pos == player_pos:
		return
	var rel = player_pos - hurtbox_pos
	rel = rel.normalized().round()
	# If not normalized, then diagonal. Don't allow diagonal movement
	if not rel.is_normalized():
		rel.y = 0
	var new_pos = hurtbox_pos + rel
	if grid.is_in_bounds(new_pos):
		hurtbox_pos = new_pos
		grid.highlight_tiles([hurtbox_pos])

func position_sprite(tween: bool) -> void:
	var new_pos = grid.get_sprite_xy(player_pos)
	if tween:
		var move_lambda = func(): can_move_player = true
		var position_tween = create_tween()
		position_tween.tween_property(sprite, "position", new_pos, TWEEN_DELAY)
		position_tween.set_trans(Tween.TRANS_EXPO)
		position_tween.tween_callback(move_lambda)
		can_move_player = false
	else:
		sprite.position = new_pos

func _on_weapon_timer_timeout() -> void:
	if dead: return
	animation.play("attack")
	animation.queue("idle")
	fire_weapon.emit(50)
	fire_bar.start(weapon_delay)

func _on_move_hurtbox_timer_timeout() -> void:
	move_hurtbox()
