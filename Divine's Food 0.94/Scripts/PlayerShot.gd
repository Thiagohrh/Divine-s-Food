extends Area2D

export var speed = 800

var screenWidth
var screenHeight

var is_inside_on_x
var is_inside_on_y

var direction = Vector2()

func _ready():
	add_to_group("PlayerShot")
	screenWidth = get_viewport_rect().size.x
	screenHeight = get_viewport_rect().size.y
	is_inside_on_x = false
	is_inside_on_y = false

func initialize(barrel_position, shot_direction):
	global_position = barrel_position
	direction = (shot_direction - barrel_position).normalized()
	rotation = direction.angle() + 0.5 * PI

func _process(delta):
	if not is_inside_screen():
		destroy()
	position += direction * speed * delta

func is_inside_screen():
	if global_position.x >= 0 and global_position.x <= screenWidth:
		is_inside_on_x = true
	else:
		is_inside_on_x = false
	
	if global_position.y >= 0 and global_position.y <= screenHeight:
		is_inside_on_y = true
	else:
		is_inside_on_y = false
	
	if is_inside_on_x and is_inside_on_y:
		return true
	
	return false

func destroy():
	queue_free()
