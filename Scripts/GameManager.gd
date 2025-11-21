extends Node

enum Level {NONE, ONE, TWO, THREE}

signal Damaged
signal Kill
signal LevelChanged


var current_level := Level.NONE: set = on_level_select
var health := 100: set = on_health_change
var level_kills := 0: set = on_kill
var level_enemies := 0
var round_timer
var scores = [0,0,0]

@onready var Player = preload("res://Scenes/player.tscn")
@onready var DethScreen = preload("res://Scenes/DeathScreen.tscn")
@onready var VictoryScreen = preload("res://Scenes/VictoryScreen.tscn")
var PlayerRef


func on_level_select(value):
	if(PlayerRef):
		PlayerRef.queue_free()
	current_level = value
	match value:
		0:
			level_kills = 0
			health = 100
		1:
			level_enemies = 5
			PlayerRef = Player.instantiate()
			get_node("/root").call_deferred("add_child", PlayerRef)
		2:
			level_enemies = 9
			PlayerRef = Player.instantiate()
			get_node("/root").call_deferred("add_child", PlayerRef)
		3:
			level_enemies = 12
			PlayerRef = Player.instantiate()
			get_node("/root").call_deferred("add_child", PlayerRef)
	LevelChanged.emit()


func on_health_change(value):
	health = value
	Damaged.emit()
	if health <= 0:
		get_tree().paused = true
		get_node("/root").call_deferred("add_child", DethScreen.instantiate())
		#reset_level()


func on_kill(value):
	level_kills = value
	Kill.emit()
	if level_kills == level_enemies:
		if scores[current_level-1] == 0 or scores[current_level-1] > round_timer.time_elapsed:
			scores[current_level-1] = round_timer.time_elapsed
		get_tree().paused = true
		get_node("/root").call_deferred("add_child", VictoryScreen.instantiate())


func reset_level():
	GameManager.health = 100
	current_level = current_level
	level_kills = 0
	LevelChanged.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_%d.tscn" % current_level)
