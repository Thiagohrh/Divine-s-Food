extends Node

enum GAME_STATE {
	In_Start_Screen,
	In_Main_Menu,
	In_Game
}

var GameScene = preload("res://Scenes/Game.tscn")

onready var StartScreen = get_node("StartScreen")
onready var MainMenu = get_node("MainMenu")
onready var GameOverScreen = get_node("GameOverScreen")
onready var GameScreenShot = get_node("GameOverScreen/GameScreenShot")

onready var background_music_node = get_node("BackgroundMusic")
onready var menu_background_music = preload("res://Sounds/Musics/Azureflux_-_06_-_Kinetic_Sands.ogg")
onready var game_background_music = preload("res://Sounds/Musics/Kero_Kero_Bonito_-_04_-_Flamingo_Azureflux_Remix.ogg")

var screen_width
var screen_height

var game
var current_state

func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	current_state = GAME_STATE.In_Start_Screen
	background_music_node.stream = menu_background_music
	background_music_node.playing = true
	$MainMenu/AnimatedSprite.play("MenuAnim")

func _unhandled_input(event):
	if event is InputEventKey:
		press_any_key(event)
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		get_tree().quit()

func new_game():
	if game != null:
		game.queue_free()
	game = GameScene.instance()
	current_state = GAME_STATE.In_Game
	add_child(game)
	game.connect("game_over", self, "on_game_over")
	background_music_node.stream = game_background_music
	background_music_node.playing = true

func on_game_over():
	game.queue_free()
	game = null
	GameOverScreen.show()

func press_any_key(event):
	if current_state == GAME_STATE.In_Start_Screen:
		StartScreen.hide()
		MainMenu.show()
		current_state = GAME_STATE.In_Main_Menu

func _on_Play_pressed():
	MainMenu.hide()
	new_game()

func _on_MainMenu_pressed():
	GameOverScreen.hide()
	MainMenu.show()

func _on_Restart_pressed():
	new_game()

func _on_Exit_pressed():
	get_tree().quit()
