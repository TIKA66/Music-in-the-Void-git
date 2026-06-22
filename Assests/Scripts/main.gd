extends Node

@onready var song_player = $SongPlayer

# Preload Obstacle's scenes
var meteor_scene = preload("res://Assests/Scenes/Obtacles/meteor.tscn")
var among_us_scene = preload("res://Assests/Scenes/Obtacles/among_us.tscn")
var crystal_block_1_scene = preload("res://Assests/Scenes/Obtacles/crystal_block_1.tscn")
var crystal_block_2_scene = preload("res://Assests/Scenes/Obtacles/crystal_block_2.tscn")
var crystal_block_3_scene = preload("res://Assests/Scenes/Obtacles/crystal_block_3.tscn")
var crystal_block_4_scene = preload("res://Assests/Scenes/Obtacles/crystal_block_4.tscn")
var crystal_shards_scene = preload("res://Assests/Scenes/Obtacles/crystal_shards.tscn")
var solar_scene = preload("res://Assests/Scenes/Obtacles/solar.tscn")
var rocket_scene = preload("res://Assests/Scenes/Obtacles/rocket.tscn")
var satellite_scene = preload("res://Assests/Scenes/Obtacles/satellite_1.tscn")
var obstacles_type := [among_us_scene, crystal_block_1_scene, crystal_block_2_scene, crystal_block_3_scene, crystal_block_4_scene, crystal_shards_scene, solar_scene ]
#var high_obstacles_type := [meteor_scene, rocket_scene, satellite_scene]
var obstacles : Array
#var higher_obstables_height := [150, 390]

# Game Variables
const PLAYER_START_POS := Vector2i(98, 470)
const CAM_START_POS := Vector2i(576, 324)
var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : float = 25.0
var screen_size : Vector2i
var ground_height : int
var score : float
const SCORE_MODIFIER : float = 20
var game_running : bool
var last_obs
var beat_timer := 0.0
var beat_interval := 0.5
var difficulty_level := 1

func _ready():
	get_tree().paused = false
	add_to_group("main")
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	set_process(false)
	$HUD.hide()
	$GameOver.hide()
	if GameData.selected_song_path != "":
		var stream = load(GameData.selected_song_path)
		if stream:
			song_player.stream = stream
	if not GameData.intro_already_played:
		$IntroAnimations.intro_finished.connect(_on_intro_finished)
	else:
		$IntroAnimations.queue_free()
		_on_intro_finished()

func _on_song_finished():
		beat_timer = 0.0
#	song_player.play()

func _on_intro_finished():
	get_tree().paused = false
	GameData.intro_already_played = true
	game_running = false
	$HUD.show()
	$GameOver.hide()
	new_game()
	set_process(true)
	if GameData.selected_song_bpm <= 0:
		GameData.selected_song_bpm = 120
	beat_interval = 60.0 / GameData.selected_song_bpm

func new_game():
	score = 0
	show_score()
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0,0)
	$HUD.get_node("Start").show()
	$HUD.get_node("Sprite2D").show()
	$HUD.get_node("Music").show()   
	if song_player.stream:
		song_player.play()

# Main Code
func _process(_delta: float) -> void:
	if game_running:
		# Updating Speed based on User's score
		speed = START_SPEED + (score / 10000)
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		# Generate obstacles according to time
		beat_timer += _delta
		while beat_timer >= beat_interval:
			beat_timer -= beat_interval
			generate_obs()
		
		# Updating node's positions
		$Player.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		show_score()
		
		# Updating platform's positions
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
			
		# Removing exited obstacles
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
	else:
		# Starts the game when the space bar is pressed
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("Start").hide()
			$HUD.get_node("Sprite2D").hide()
			$HUD.get_node("Music").hide()

# Displaying image according to score modifier
func show_score():
	$HUD.get_node("Score").text = "SCORE:" + str(int(score / SCORE_MODIFIER))
	if int(score / SCORE_MODIFIER) % 100 == 0:
		$Points.play()    

# Generate Obstacles
func generate_obs():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacles_type[randi() % obstacles_type.size()]
		var obs
		#var max_obs = 3
		
		obs = obs_type.instantiate()
		var sprite = obs.get_node("AnimatedSprite2D")
		var obs_height = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_height()
		var obs_scale = obs.get_node("AnimatedSprite2D").scale
		var obs_x : int = screen_size.x + score + 100
		var obs_y :int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
		
		# Add a chance to randomly spawn rockets
		#var hobs_type = high_obstacles_type.pick_random()
		#var hobs
		
		#if (randi() % 2) == 0:
		#	hobs = hobs_type.instantiate()
		#	var hobs_x : int = screen_size.x + score + 100
		#	var hobs_y : int = higher_obstables_height[randi() % higher_obstables_height.size()]
		#	add_obs(hobs, hobs_x, hobs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Player":
		game_over()

func update_difficulty():
	difficulty_level = (
		GameData.selected_song_difficulty + int(score / 3000))
	difficulty_level = min(difficulty_level, 5)

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOverMusic.play()
	$GameOver.show()
