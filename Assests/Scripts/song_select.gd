extends Control

@onready var item_list = $ItemList
@onready var preview_player = $AudioPreviewPlayer
@onready var song_name = $SongNameLabel

# NEW FEATURE: Displays song difficulty
@onready var difficulty_label = $DifficultyLabel

var selected_path = ""

func _ready():
	$PlayButton.disabled = true
	load_songs()

func load_songs():
	item_list.clear()
	for song_name_key in GameData.songs.keys():
		item_list.add_item(song_name_key)


# User selects song
func _on_item_list_item_activated(index: int):
	var song_title = item_list.get_item_text(index)
	var song_data = GameData.songs[song_title]

	GameData.selected_song_name = song_title
	GameData.selected_song_path = song_data.path
	GameData.selected_song_bpm = song_data.bpm
	GameData.selected_song_difficulty = song_data.difficulty

	selected_path = song_data.path
	song_name.text = song_title

	difficulty_label.text = "Difficulty: " + "★".repeat(song_data.difficulty)
	var stream = load(selected_path)
	if stream:
		preview_player.stream = stream
		preview_player.play()
	$PlayButton.disabled = false


# Start game
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Assests/Scenes/main.tscn")
