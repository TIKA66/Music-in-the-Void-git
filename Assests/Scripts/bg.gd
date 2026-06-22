extends ParallaxBackground

func _ready():
	start_star_twinkle($Stars1/Sprite2D, 0.3, 0.8)
	start_star_twinkle($Stars2/Sprite2D, 0.1, 0.5)
	start_star_twinkle($Stars3/Sprite2D, 0.4, 1.0)

func start_star_twinkle(star_layer: Sprite2D, min_alpha: float, max_alpha: float):
	while true:
		var target_alpha = randf_range(min_alpha, max_alpha)
		var duration = randf_range(1.0, 4.0)

		var tween = create_tween()
		tween.tween_property(
			star_layer,
			"modulate:a",
			target_alpha,
			duration
		)

		await tween.finished
