extends CanvasLayer

#@onready var restart_btn := %Restart
#@onready var back_btn := %Back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	GameManager.reset_level()
	get_tree().paused = false
	queue_free()


func _on_back_pressed() -> void:
	GameManager.current_level = GameManager.Level.NONE
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/LevelSelector.tscn")
	get_tree().paused = false
	queue_free()
