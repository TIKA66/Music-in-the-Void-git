extends Node2D

@onready var intro_label = $Label
signal intro_finished

var messages = [
	"The sky cracked first.",
	"Then the worlds.",
	"Then the memories.",
	"Now only silence remains.",
	"But silence never lasts.",
	"Listen closely.",
	"Can you hear it?",
	"A heartbeat.",
	"A song.",
	"Follow the rhythm.",
	"Survive."
]

var current_message := 0

func _ready():
	show_intro()
	start_star_twinkle($Star1, 0.3, 0.8)
	start_star_twinkle($Star2, 0.1, 0.5)
	start_star_twinkle($Star3, 0.4, 1.0)

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

func show_intro():
	$Creepy_Intro.play()
	for text in messages:
		intro_label.text = text
		intro_label.modulate.a = 0

		# Fade in
		var tween = create_tween()
		tween.tween_property(intro_label, "modulate:a", 1.0, 1.0)
		await tween.finished

		await get_tree().create_timer(1.5).timeout

		# Fade out
		tween = create_tween()
		tween.tween_property(intro_label, "modulate:a", 0.0, 1.0)
		await tween.finished

		await get_tree().create_timer(0.2).timeout
	
	intro_label.visible = false
	$FarBackBG.visible = false
	$Star1.visible = false
	$Star2.visible = false
	$Star3.visible = false
	$Creepy_Intro.stop()
	intro_finished.emit()
	queue_free()
