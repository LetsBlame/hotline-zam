extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_time = GameManager.round_timer.time_elapsed
	var lt_min = floor(level_time / 60)
	var lt_sec = fmod(level_time, 60)
	%LevelTime.text = "%02d:%05.2f" % [lt_min, lt_sec]
	var best_time = GameManager.scores[GameManager.current_level-1]
	var bt_min = floor(best_time / 60)
	var bt_sec = fmod(best_time, 60)
	%BestTime.text = "%02d:%05.2f" % [bt_min, bt_sec]
	if level_time == best_time:
		%NewRecord.visible = true


func _on_restart_pressed() -> void:
	GameManager.reset_level()
	get_tree().paused = false
	queue_free()


func _on_back_pressed() -> void:
	GameManager.current_level = GameManager.Level.NONE
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/LevelSelector.tscn")
	get_tree().paused = false
	queue_free()
