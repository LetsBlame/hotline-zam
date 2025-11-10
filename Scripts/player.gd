extends CharacterBody2D

enum State {IDLE, AIMING, SHOOTING, RELOADING}

@export var speed := 200
#@export var max_health: int = 100 
#var health: int
var arrow = preload("res://Scenes/Arrow.tscn")

#var aiming := false
var current_state := State.IDLE

#func _ready() -> void:
	##health = max_health
	#print(GameManager.current_level)

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#event.get_screen_relative()
	if current_state == State.IDLE:
		if event.is_action_pressed("Aim"):
			current_state = State.AIMING
			$Anims.play("Aim")
			if GameManager.current_level == 1:
				%HeadLight.enabled = false
				%FlashLight.enabled = true
	
	if current_state == State.AIMING:
		if event.is_action_released("Aim"):
			$Anims.play("UnAim")
			
			if GameManager.current_level == 1:
				%HeadLight.enabled = true
				%FlashLight.enabled = false
		if event.is_action_pressed("Shoot"):
			current_state = State.SHOOTING
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

func take_damage(damage: int):
	$HurtAnim.play("Hurt")
	GameManager.health -= damage
	#if GameManager.health <= 0:



func shoot():
	var bullet = arrow.instantiate()
	bullet.transform = %ShootPosition.global_transform
	#bullet.rotation -= 90
	get_node("/root").add_child(bullet)
	#current_state = State.IDLE
	pass


func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		#"Aim":
			#current_state = State.AIMING
		"Shoot":
			current_state = State.RELOADING
			$Anims.play("Reload")
			if not Input.is_action_pressed("Aim"):
				if GameManager.current_level == 1:
					%HeadLight.enabled = true
					%FlashLight.enabled = false
		"UnAim":
			current_state = State.IDLE
		"Reload":
			if not Input.is_action_pressed("Aim"):
				current_state = State.IDLE
				if GameManager.current_level == 1:
					%HeadLight.enabled = true
					%FlashLight.enabled = false
			else:
				current_state = State.AIMING
				$Anims.play("Aim")
	pass # Replace with function body.
