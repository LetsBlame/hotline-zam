extends CanvasLayer

func _on_restart_pressed() -> void:
	GameManager.reset_level()
	get_tree().paused = false
	queue_free()


func _on_back_pressed() -> void:
	GameManager.current_level = GameManager.Level.NONE
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/LevelSelector.tscn")
	get_tree().paused = false
	queue_free()
