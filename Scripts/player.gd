extends CharacterBody2D

enum State {IDLE, AIMING, SHOOTING, RELOADING}

@export var speed := 200

var arrow = preload("res://Scenes/Arrow.tscn")
var current_state := State.IDLE

func _ready() -> void:
	if GameManager.current_level != 1:
		%HeadLight.enabled = true


func _input(event: InputEvent) -> void:
	if current_state == State.IDLE:
		if event.is_action_pressed("Aim"):
			current_state = State.AIMING
			$Anims.play("Aim")
			if GameManager.current_level != 1:
				%HeadLight.enabled = false
				%FlashLight.enabled = true
	
	if current_state == State.AIMING:
		if event.is_action_released("Aim"):
			$Anims.play("UnAim")
			
			if GameManager.current_level != 1:
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


func take_damage(damage: int):
	$HurtAnim.play("Hurt")
	$SwordHit.play()
	GameManager.health -= damage


func shoot():
	var bullet = arrow.instantiate()
	bullet.transform = %ShootPosition.global_transform
	get_node("/root").add_child(bullet)


func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Shoot":
			current_state = State.RELOADING
			$Anims.play("Reload")
			if not Input.is_action_pressed("Aim"):
				if GameManager.current_level != 1:
					%HeadLight.enabled = true
					%FlashLight.enabled = false
		"UnAim":
			current_state = State.IDLE
		"Reload":
			if not Input.is_action_pressed("Aim"):
				current_state = State.IDLE
				if GameManager.current_level != 1:
					%HeadLight.enabled = true
					%FlashLight.enabled = false
			else:
				current_state = State.AIMING
				$Anims.play("Aim")
