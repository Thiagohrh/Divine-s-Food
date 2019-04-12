extends Node

var Follow = load("res://addons/CustomFollow2DPlugin/Follow.gd")

export (PackedScene) var Client

onready var hud = get_node("HUD")
onready var player = get_node("Player")
onready var paths = get_node("PathHolder")
onready var match_timer = get_node("Timers/MatchTimer")
onready var score_updater_timer = get_node("Timers/ScoreUpdaterTimer")
onready var client_spawn_timer = get_node("Timers/ClientSpawnTimer")
onready var client_manager = get_node("ClientManager")
onready var game_over_sfx = get_node("SoundEffects/GameOver")
onready var spoted = get_node("SpotedScript")

var score = 0
var game_is_running = false

signal game_over

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var time_left = int(match_timer.time_left)
	hud.connect("start_game", self, "start_game")
	hud.update_timer(time_left)
	hud.update_score(score)
	client_manager.connect("client_was_shot", self, "add_score")
	client_manager.initialize(paths, client_spawn_timer)

func _process(delta):
	if game_is_running:
		var time_left = int(match_timer.time_left)
		hud.update_timer(time_left)
		player.update(delta)
		client_manager.update(delta)

func start_game():
	if match_timer.is_stopped():
		match_timer.start()
	hud.update_score(score)
	game_is_running = true

func add_score(object):
	score += object.get_score()

func game_over():
	game_is_running = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("game_over")

func _on_MatchTimer_timeout():
	game_over()
	game_over_sfx.playing = true

func _on_ScoreUpdaterTimer_timeout():
	hud.update_score(score)
	score_updater_timer.start()

func _exitGame(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		get_tree().quit()
