extends CanvasLayer

onready var start_countdown = get_node("StartCountdown")
onready var start_countdown_timer = get_node("StartCountdown/Timer")
onready var start_countdown_label = get_node("StartCountdown/Label")
onready var match_timer_label = get_node("Timer/Label")
onready var score_label = get_node("Score/Label")

signal start_game

func _process(delta):
	if start_countdown_timer.time_left > 1:
		var time_left = int(start_countdown_timer.time_left)
		start_countdown_label.text = str(time_left)
	else:
		start_countdown.hide()

func update_score(score):
	score_label.text = str(score)

func update_timer(time):
	match_timer_label.text = str(time)

func _on_Timer_timeout():
	emit_signal("start_game")
