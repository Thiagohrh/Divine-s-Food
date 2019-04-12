extends Node

export(PackedScene) var Enemy
onready var spawn_points = get_node("EnemySpawnPoints")
onready var timer = get_node("EnemyTimer")

func _ready():
	
	pass

func _process(delta):
	if timer.is_stopped():
		timer.start()
		pass
	randomize()
	
	pass


func _on_EnemyTimer_timeout():
	print("Spawning Enemy")
	_spawn_enemy()
	pass

func _spawn_enemy():
	#should instance an Enemy!
	var spawn_location
	var num = randi() % spawn_points.get_child_count()
	spawn_location = spawn_points.get_child(num)
	
	if num < 2: #if the enemy spawns on the bottom of the screen
		var enemy_instance = Enemy.instance()
		add_child(enemy_instance)
		enemy_instance._initialize(spawn_location.global_position, Vector2(0, -1))
		pass
	else: #if the enemy spawns on the left of the screen
		var enemy_instance = Enemy.instance()
		add_child(enemy_instance)
		enemy_instance._initialize(spawn_location.global_position, Vector2(1, 0))
		pass
	pass