extends KinematicBody2D

export(PackedScene) var arrowTarget

const ACCELERATION = 35
const DEACCELERATION_PERCENTAGE = 0.2
const MAX_SPEED = 250

onready var collider = get_node("Collider")
onready var sprite = get_node("Sprite")
onready var gun = get_node("PlayerGun")
onready var stun_timer = get_node("StunTimer")

var motion = Vector2()
var direction = Vector2()

var stunned = false

func _ready():
	add_to_group("Player")
	var gun_position_node = get_node("GunPositionNode")
	var gun_barrel_position_node = get_node("GunPositionNode/BarrelPositionNode")
	gun.initialize(gun_position_node, gun_barrel_position_node)
	var a_target = arrowTarget.instance()
	self.add_child(a_target)
	stunned = false

func update(delta):
	var mouse_position = get_global_mouse_position()
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var fire = Input.is_action_just_pressed("ui_fire")
	
	if not stunned:
		update_direction(right, left, up, down)
		update_motion(right, left, up, down)
		play_idle_animation()
		update_sprites_shoot()
		
		if fire:
			shoot(mouse_position)
		
		move_and_slide(motion)
		pass
	

func update_motion(right, left, up, down):
	if right:
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	elif left:
		motion.x = max (motion.x - ACCELERATION, -MAX_SPEED)
	else:
		motion.x = lerp(motion.x, 0, DEACCELERATION_PERCENTAGE)
	
	if up:
		motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)
	elif down:
		motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
	else:
		motion.y = lerp(motion.y, 0, DEACCELERATION_PERCENTAGE)

func update_direction(right, left, up, down):
	if right:
		direction.x = 1
		if not up and not down:
			direction.y = 0
	elif left:
		direction.x = -1
		if not up and not down:
			direction.y = 0
	if up:
		direction.y = -1
		if not left and not right:
			direction.x = 0
	elif down:
		direction.y = 1
		if not left and not right:
			direction.x = 0
	pass

func shoot(mouse_position):
	gun.shoot(mouse_position)

func update_sprites_shoot():
	if (gun.get_magazine() >= 0):
		if (gun.get_magazine() == 5):
			$AnimatedSprite.play("Shoot_01")
		if (gun.get_magazine() == 4):
			$AnimatedSprite.play("Shoot_02")
		if (gun.get_magazine() == 3):
			$AnimatedSprite.play("Shoot_03")
		if (gun.get_magazine() == 2):
			$AnimatedSprite.play("Shoot_04")
		if (gun.get_magazine() == 1):
			$AnimatedSprite.play("Shoot_05")
		if (gun.get_magazine() == 0):
			$AnimatedSprite.play("Shoot_05")

func play_idle_animation():
	if (gun.get_magazine() == 6):
		$AnimatedSprite.play("IdleShots")

func stun_me():
	if stunned == false and stun_timer.is_stopped():
		stunned = true
		stun_timer.start()
		pass
	pass

func _on_StunTimer_timeout(): #Should DE-stun itself

	stunned = false
	
	pass # replace with function body
