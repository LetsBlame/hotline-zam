class_name  AutoDeleteAudio
extends AudioStreamPlayer2D

func _init(setup_stream: AudioStream) -> void:
	stream = setup_stream


func _ready() -> void:
	play()
	finished.connect(on_audio_finished)


func on_audio_finished():
	queue_free()
