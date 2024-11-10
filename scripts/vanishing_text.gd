extends Label

@onready var timer = $FinishedTimer

const DELAY: int = 1

func start(txt: String, color: Color = Color.WHITE) -> void:
	set_text(txt)
	add_theme_color_override("font_color", color)
	
	var position_tween = get_tree().create_tween()
	position_tween.tween_property(self, "position:y", -50, DELAY)
	
	var opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", 0.0, DELAY)
	opacity_tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	
	timer.start(DELAY)

func _on_finished_timer_timeout() -> void:
	queue_free()
