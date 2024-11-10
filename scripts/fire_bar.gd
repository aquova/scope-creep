extends ProgressBar

var tween: Tween

func start(delay: float) -> void:
	if tween:
		tween.kill()
	set_value_no_signal(0)
	tween = create_tween()
	tween.tween_property(self, "value", 100, delay)
