extends Node

enum Level {NONE, ONE, TWO}

signal Damaged
signal Kill
signal LevelChanged
	

var current_level := Level.NONE: set = on_level_select
var health := 100: set = on_health_change
var level_kills := 0: set = on_kill
var level_enemies := 0
var round_timer
var scores = [0,0,0]

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass

func on_level_select(value):
	current_level = value
	match value:
		0:
			level_kills = 0
			health = 100
		1:
			level_enemies = 2
		2:
			level_enemies = 20
	LevelChanged.emit()

func on_health_change(value):
	health = value
	Damaged.emit()
	if health <= 0:
		reset_level()
	
func on_kill(value):
	level_kills = value
	Kill.emit()
	if level_kills == level_enemies:
		scores[current_level-1] = round_timer.time_elapsed
		print(scores)
		current_level = Level.NONE
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/LevelSelector.tscn")
		
func reset_level():
	GameManager.health = 100
	level_kills = 0
	LevelChanged.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_%d.tscn" % current_level)
	
