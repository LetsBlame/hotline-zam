extends Area2D

@export var speed: float = 500.0
@export var damage: int = 25

var blocked = false
var impact_sound = preload("res://Sounds/RandomImpact.tres")

func _physics_process(delta):
	if not blocked:
		position += transform.x * speed * delta


func _on_hit(body: Node2D) -> void:
	var audio_player = AutoDeleteAudio.new(impact_sound)
	audio_player.volume_db = -12
	get_parent().add_child(audio_player)
	
	if not blocked:
		$AnimatedSprite2D.frame = 1
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()


func _on_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Shield"):
		blocked = true
		queue_free()
