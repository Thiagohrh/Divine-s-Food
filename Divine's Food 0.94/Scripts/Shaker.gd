extends Node

onready var camera = get_parent()
var time = 0
const duration = 0.25
const magnitude = 3


func _ready():
	
	pass

func _process(delta):
	
	pass

func shake():
	var initial_offset = camera.get_offset()
	while time < duration:
		time += get_process_delta_time()
		time = min(time, duration)
		
		var offset = Vector2()
		offset.x = rand_range(-magnitude, magnitude)
		offset.y = rand_range(-magnitude, magnitude)
		camera.set_offset(initial_offset + offset)
		
		yield(get_tree(), "idle_frame")
		pass
	
	time = 0
	camera.set_offset(initial_offset)
	pass