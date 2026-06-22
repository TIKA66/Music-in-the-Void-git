extends Node

var selected_song_path := ""
var selected_song_difficulty := 1
var selected_song_bpm := 120
var selected_song_name := ""
var intro_already_played := false

var songs := {
	"I Wanna Be Yours": {
		"path": "res://Assests/Music/I Wanna Be Yours.mp3",
		"bpm": 68,
		"difficulty": 1
	},
	"Stateside": {
		"path": "res://Assests/Music/PinkPantheress - Stateside  Zara Larsson (Official Video).mp3",
		"bpm": 140,
		"difficulty": 3
	},
	"Party In The USA": {
		"path": "res://Assests/Music/Miley Cyrus - Party In The U.S.A (Lyrics).mp3",
		"bpm": 96,
		"difficulty": 2
	},
	"Sparks": {
		"path": "res://Assests/Music/@coldplay  - Sparks (Lyrics).mp3",
		"bpm": 74,
		"difficulty": 1
	},
	"Dracula": {
		"path": "res://Assests/Music/Tame Impala - Dracula (Official Video).mp3",
		"bpm": 118,
		"difficulty": 3
	},
	"the cure": {
		"path": "res://Assests/Music/noname.mp3",
		"bpm": 120,
		"difficulty": 3
	},
	"Something In The Orange": {
		"path": "res://Assests/Music/Zach Bryan - Something In The Orange.mp3",
		"bpm": 55,
		"difficulty": 1
	},
	"Drag Path": {
		"path": "res://Assests/Music/Twenty One Pilots - Drag Path (Official Video).mp3",
		"bpm": 90,
		"difficulty": 2
	},
	"Madwoman": {
		"path": "res://Assests/Music/Laufey - Madwoman (Official Music Video).mp3",
		"bpm": 80,
		"difficulty": 2
	},
	"From The Start": {
		"path": "res://Assests/Music/Laufey - From The Start (Official Music Video).mp3",
		"bpm": 174,
		"difficulty": 5
	}
}
