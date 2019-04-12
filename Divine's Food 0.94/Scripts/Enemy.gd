extends Area2D

enum GAME_STATE {
	Calm,
	Aggro,
	Stationary
}

export(PackedScene) var explosion

var speed = 3

var current_state = Calm
var current_direction = Vector2()

var entered_screen = false
var exited_screen = false
var screenWidth
var screenHeight

var is_inside_on_x = false
var is_inside_on_y = false

onready var sprite = get_node("Sprite")
onready var angry_sprite = get_node("AngrySprite")
onready var pistola_timer = get_node("PistolaTimer")
onready var scream = get_node("Scream")

var player_node

func _ready():
	add_to_group("Enemy")
	if not sprite.is_playing():
		sprite.play("Run")
	
	
	screenWidth = get_viewport_rect().size.x
	screenHeight = get_viewport_rect().size.y
	pass

func _process(delta):
	
	if current_state == GAME_STATE.Calm:
		_calm_behaviour()
	elif current_state == GAME_STATE.Aggro:
		_aggro_behaviour()
	pass
	
	if is_inside_screen() and entered_screen == false: # se está na tela, mas o bool ainda não foi alterado, altera.
		entered_screen = true
		pass
	
	if not is_inside_screen() and entered_screen: #Se já entrou na tela, mas não está mais, se deleta.
		_delete_myself()
		pass


func _initialize(_position, direction):
	global_position = _position
	current_direction = direction
	pass

func _calm_behaviour(): #Should only execute if its calm.
	global_position += current_direction * speed
	pass

func _aggro_behaviour(): #Should only execute if it has been hit
	#print(player_node[0].global_position)
	var _vector_to_player = (player_node[0].global_position - global_position).normalized()
	
	global_position += _vector_to_player * speed * 2
	
	pass

func is_inside_screen():
	if global_position.x >= -10 and global_position.x <= screenWidth + 10:
		is_inside_on_x = true
	else:
		is_inside_on_x = false
	
	if global_position.y >= 0 and global_position.y <= screenHeight:
		is_inside_on_y = true
	else:
		is_inside_on_y = false
	
	if is_inside_on_x and is_inside_on_y:
		return true
	else:
		return false

func _delete_myself():
	queue_free()

func _on_Enemy_area_entered(area): #if Collides with another area2D...
	if area.is_in_group("PlayerShot") and current_state == GAME_STATE.Calm: #If it was calm, and was shot...
		if pistola_timer.is_stopped():
			angry_sprite.play("Angry")
			sprite.play("Idle")
			pistola_timer.start()
			scream.play()
			current_state = GAME_STATE.Stationary
			pass
		pass
	pass # replace with function body


func _on_PistolaTimer_timeout():
	current_state = GAME_STATE.Aggro
	sprite.play("Run")
	
	player_node = get_tree().get_nodes_in_group("Player")
	
	pass # replace with function body


func _on_Enemy_body_entered(body): #if Collides with a Kinematic Body...
	if body.is_in_group("Player") and current_state == GAME_STATE.Aggro:
		body.stun_me()
		var new_explosion = explosion.instance()
		get_parent().add_child(new_explosion)
		new_explosion.global_position = global_position
		_delete_myself()
		pass
	pass # replace with function body
