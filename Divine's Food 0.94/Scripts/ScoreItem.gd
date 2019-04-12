extends HBoxContainer

var position = "10TH" setget set_position
var player_name = "F21" setget set_name
var score = "99999" setget set_score

func set_position(new_position):
	position = new_position
	get_node("Position").text = (str(position))

func set_name(new_name):
	player_name = new_name
	get_node("Name").text = (str(player_name))

func set_score(new_score):
	score = new_score
	get_node("Score").text = (str(score))
