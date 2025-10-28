extends Control


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelSelector.tscn")



func _on_quit_btn_pressed() -> void:
	get_tree().quit()
