extends Control

@onready var levels_container = %Levels

func _ready() -> void:
	var levels = levels_container.get_children()
	for level in levels:
		var level_num = level.get_index()+1
		var button = Button.new()
		button.text = "Nivel %d" % level_num
		button.custom_minimum_size = Vector2(200, 60)
		button.connect("pressed", _on_level_button_pressed.bind(level_num))
		level.add_child(button)
		
		var label = Label.new()
		label.text = "\t" + str(GameManager.scores[level.get_index()])
		level.add_child(label)
	
	
	
	
	#create_level_buttons()
	pass

func _process(_delta: float) -> void:
	pass

func _on_level_button_pressed(level_num):
	GameManager.current_level = level_num
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_%d.tscn" % level_num)
	

#func create_level_buttons() ->void:
	#pass
