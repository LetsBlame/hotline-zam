extends Control

@onready var levels_container = %Levels
@onready var scores_container = %HighScores

func _ready() -> void:
	var levels = levels_container.get_children()
	var scores = scores_container.get_children()
	for level in levels:
		var level_num = level.get_index()+1
		var button = Button.new()
		button.text = "Nivel %d" % level_num
		button.custom_minimum_size = Vector2(200, 60)
		button.connect("pressed", _on_level_button_pressed.bind(level_num))
		level.add_child(button)

		var level_time = GameManager.scores[level.get_index()]
		var minutes = floor(level_time / 60)
		var seconds = fmod(level_time, 60)
		scores[level.get_index()].text = "--:--.-" if level_time ==0 else "%02d:%05.2f" % [minutes, seconds]


func _on_level_button_pressed(level_num):
	GameManager.current_level = level_num
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_%d.tscn" % level_num)


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
