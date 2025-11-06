extends Area2D

@export var speed: float = 500.0
@export var damage: int = 10

var blocked = false

func _ready():
	pass
	#area_entered.connect(_on_hit)
	#body_entered.connect(_on_hit)

func _physics_process(delta):
	if not blocked:
		position += transform.x * speed * delta
	#print(position)

#func _on_hit(hit_target):
	#if hit_target.has_method("take_damage"):
		#hit_target.take_damage(damage)
	#queue_free()


func _on_hit(body: Node2D) -> void:
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
