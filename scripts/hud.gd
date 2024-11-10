extends CanvasLayer

@onready var xp_bar = $XpBar

const XP_BAR_TIME = 0.5

func set_xp(xp: int) -> void:
	var tween = create_tween()
	tween.tween_property(xp_bar, "value", xp, XP_BAR_TIME)

func set_max_xp(max: int) -> void:
	xp_bar.max_value = max
