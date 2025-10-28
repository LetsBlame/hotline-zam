extends CharacterBody2D

@export var speed: int = 200
@export var max_health: int = 100 
var health: int 

func _ready() -> void:
	health = max_health


func _physics_process(_delta: float) -> void:
	
	var input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("Up"): input_dir.y -= 1
	if Input.is_action_pressed("Down"): input_dir.y += 1
	if Input.is_action_pressed("Left"): input_dir.x -= 1
	if Input.is_action_pressed("Right"): input_dir.x += 1
	
	if input_dir:
		velocity = input_dir.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Shoot"):
		shoot()

func shoot():
	pass
