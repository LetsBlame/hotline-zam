extends Node2D

@onready var label = $Label

var time_elapsed := 0.0
var running := false

func _enter_tree() -> void:
	GameManager.round_timer = self

func _ready() -> void:
	reset_timer()
	start_timer()
	update_label()

func _process(delta: float) -> void:
	if running:
		time_elapsed += delta
		update_label()

func update_label():
	var minutes = floor(time_elapsed / 60)
	var seconds = fmod(time_elapsed, 60)
	label.text = "Tiempo: %02d:%05.2f" % [minutes, seconds]

func start_timer():
	time_elapsed = 0.0
	running = true

func stop_timer():
	running = false

func reset_timer():
	time_elapsed = 0.0
	running = false
	update_label()
