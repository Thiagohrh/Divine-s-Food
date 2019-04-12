extends VBoxContainer

var item_score_prefab = preload("res://Scenes/ScoreItem.tscn")

func _ready():
	for a in range(10):
		var item = item_score_prefab.instance()
		item.playerName = str(a) + "AA"
		add_child(item)
