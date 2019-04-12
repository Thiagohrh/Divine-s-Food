extends Area2D

export (PackedScene) var ps_projectile

onready var projectile_container = get_node("ProjectileContainer")
onready var fire_rate_timer = get_node("FireRateTimer")

var magazine_max_ammount = 6
var magazine = magazine_max_ammount

var gun
var barrel

func _ready():
	pass

func initialize(gun_position_node, barrel_position_node):
	gun = gun_position_node
	barrel = barrel_position_node
	global_position = gun.global_position

func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	if magazine < magazine_max_ammount and fire_rate_timer.is_stopped():
		fire_rate_timer.start()

func shoot(direction):
	if magazine > 0:
		var projectile = ps_projectile.instance()
		projectile_container.add_child(projectile)
		projectile.initialize(barrel.global_position, direction)
		magazine -= 1

func _on_FireRateTimer_timeout():
	magazine += 1
	
func get_magazine():
	#getMaga = magazine
	return magazine