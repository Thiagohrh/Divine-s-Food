extends Node

var Follow = load("res://addons/CustomFollow2DPlugin/Follow.gd")

onready var shaker = get_parent().get_node("Camera2D/Shaker")
export (PackedScene) var Client
export (PackedScene) var SpotedBar

export var spawn_rate = 2
export var spawn_rand_margin = 4

var clients = []
var follows = []

var paths = null
var spawn_timer = null

signal client_was_shot(object)

func initialize(client_paths, client_spawn_timer):
	randomize()
	paths = client_paths
	spawn_timer = client_spawn_timer

func update(delta):
	if spawn_timer.is_stopped():
		spawn_timer.wait_time = spawn_rate + (randi() % spawn_rand_margin)
		spawn_timer.start()
	
	for i in range(0, follows.size()):
		follows[i].update(delta)
	for i in range(0, clients.size()):
		clients[i].update(delta)

func instantiate_path_follow():
	var follow = Follow.new()
	follow.connect("destroyed", self, "on_follow_destroyed")
	var paths_number = paths.get_child_count() - 1
	var chosen_path = paths.get_child(randi() % paths_number)
	chosen_path.add_child(follow)
	follows.append(follow)
	return follow

func instantiate_client():
	var path_follow = instantiate_path_follow()
	var client = Client.instance()
	client.connect("was_shot", self, "on_client_was_shot")
	client.connect("destroyed", self, "on_client_destroyed")
	add_child(client)
	var new_position = path_follow.global_position
	client.initialize(new_position, path_follow)
	clients.append(client)

func go_to_restaurant(object):
	var follow = Follow.new()
	var restaurant_path = paths.get_child(8)
	restaurant_path.add_child(follow)
	follows.append(follow)
	object.change_target(follow)

func on_follow_destroyed(object):
	follows.erase(object)

func on_client_was_shot(object):
	shaker.shake()
	emit_signal("client_was_shot", object)
	go_to_restaurant(object)

func on_client_destroyed(object):
	clients.erase(object)

func _on_ClientSpawnTimer_timeout():
	var s_spoted = SpotedBar.instance()
	self.add_child(s_spoted)
	s_spoted.get_node("SpotedSprite").play("SpotedAnim")
	instantiate_client()
