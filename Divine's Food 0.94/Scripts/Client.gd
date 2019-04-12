extends Area2D

onready var sprite = get_node("Sprite")
onready var life_time = get_node("LifeTime")

var target
var last_target_location
var converted
var reached_end

var score = 10
var speed = 10

signal was_shot(object)
signal destroyed(object)

func _ready():
	add_to_group("Clients")
	target = null
	converted = false
	reached_end = false
	$AnimatedSprite.play("ClientDown")

func initialize(location, path_target):
	position = location
	target = path_target

func update(delta):
	if reached_end:
		$AnimatedSprite.play("ClientUp")
		$AnimatedSprite.self_modulate.a = $LifeTime.time_left / $LifeTime.wait_time
		sprite.self_modulate.a = $LifeTime.time_left / $LifeTime.wait_time
	
	if target != null:
		last_target_location = target.global_position
		var direction = (last_target_location - position).normalized()
		position.x = lerp(position.x, last_target_location.x, delta * speed)
		position.y = lerp(position.y, last_target_location.y, delta * speed)
		if target.get_is_at_end():
			reached_end = true
			target.set_not_followed_anymore()
			target = null
			if life_time.is_stopped():
				life_time.start()

func set_target_as_null():
	target = null

func change_target(path_target):
	if target != null:
		target.set_not_followed_anymore()
	target = path_target

func get_score():
	return score

func _on_Client_area_entered(area):
	if area.is_in_group("PlayerShot") and not converted and not reached_end:
		emit_signal("was_shot", self)
		converted = true
		if area.has_method("destroy"):
			area.destroy()

func destroy():
	emit_signal("destroyed", self)
	queue_free()

func _on_LifeTime_timeout():
	destroy()
	
func get_Client():
	return reached_end
