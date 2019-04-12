extends PathFollow2D

export var running_speed = 360

var is_at_the_end
var being_followed

onready var life_time = get_node("LifeTime")

signal destroyed(object)

func _ready():
	is_at_the_end = false
	being_followed = true
	loop = false

func update(delta):
	if unit_offset < 1:
		offset = offset + running_speed * delta
	else:
		is_at_the_end = true
	
#	if is_at_the_end and not being_followed:
#		if life_time.is_stopped():
#			life_time.start()

func get_is_at_end():
	return is_at_the_end

func set_not_followed_anymore():
	being_followed = false

func destroy():
	emit_signal("destroyed", self)
	queue_free()

func _on_LifeTime_timeout():
	destroy()
