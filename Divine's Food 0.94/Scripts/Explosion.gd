extends Area2D

onready var sfx = get_node("AudioStreamPlayer")
onready var sprite = get_node("AnimatedSprite")
onready var timer = get_node("TimeToDie")

func _ready():
	if not sfx.playing:
		sfx.play()
		print("Should have started...")
	
	if timer.is_stopped():
		timer.start()
	
	sprite.frame = 0
	pass

func _process(delta):
	
	pass


func _on_AudioStreamPlayer_finished():
	print("The sound has stopped!")
	pass # replace with function body


func _on_TimeToDie_timeout():
	queue_free()
	pass # replace with function body
