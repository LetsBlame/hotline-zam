extends CharacterBody2D

@export var speed: int = 200
@export var max_health: int = 100 
var health: int
var aiming := false

func _ready() -> void:
	health = max_health

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Aim"):
		aiming = true
		%HeadLight.enabled = false
		%FlashLight.enabled = true
		$Anims.play("Aim")

	if event.is_action_released("Aim"):
		aiming = false
		%HeadLight.enabled = true
		%FlashLight.enabled = false
		$Anims.play("UnAim")
		
	if event.is_action_pressed("Shoot") and aiming:
		$Anims.play("Shoot")
		shoot()
		

func _physics_process(_delta: float) -> void:
	
	velocity = Input.get_vector("Left","Right","Up","Down") * speed
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	
	#var input_dir = Vector2.ZERO
	#
	#if Input.is_action_pressed("Up"): input_dir.y -= 1
	#if Input.is_action_pressed("Down"): input_dir.y += 1
	#if Input.is_action_pressed("Left"): input_dir.x -= 1
	#if Input.is_action_pressed("Right"): input_dir.x += 1
	#
	#if input_dir:
		#velocity = input_dir.normalized() * speed
	#else:
		#velocity = Vector2.ZERO




func shoot():
	pass
