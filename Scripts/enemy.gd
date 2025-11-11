extends CharacterBody2D

enum state {IDLE, WANDER, CHASE, ATTACK}

@export var speed := randi_range(140,170)
@export var damage := 20
@export var health:= 70 : set = on_health_changed
@export var attack_radius := 100

@onready var NavAgent := get_node("%NavAgent")
@onready var PlayerRef: CharacterBody2D = GameManager.PlayerRef

var death_sound = preload("res://Sounds/RandomDeathSplash.tres")
var splatter = preload("res://Scenes/blood_splatter.tscn")

var type: int
var shielded: int
var movement_delta: float
var current_state:= state.IDLE


func _ready() -> void:
	type = randi_range(0,2)
	shielded = randi_range(0,2)
	$Timer.wait_time = randf_range(0.5,3.5)
	$Timer.start()
	
	%Sword.frame = type
	%Shield.frame = shielded
	match type:
		0:
			%SwordCollision.shape.size = Vector2(8,38)
			%SwordCollision.position = Vector2(1,-6)
		1: 
			%SwordCollision.shape.size = Vector2(38,33)
			%SwordCollision.position = Vector2(1,-8.5)
		2:
			%SwordCollision.shape.size = Vector2(29,17)
			%SwordCollision.position = Vector2(0.5,-16.5)
	%SwordArea.body_entered.connect(_on_sword_hit)
	
	#PlayerRef = 
	#var player_transform = PlayerRef.get_global_transform()
	#print(player_transform.origin)
	#set_movement_target(player_transform.origin)
	#set_movement_target(Vector2(player_transform.x,player_transform.y))
	#pass
	#NavAgent.velocity_computed.connect(Callable(_on_velocity_computed))

func _process(_delta: float) -> void:
	#$ProgressBar.global_position = global_position
	if current_state == state.CHASE:
		if global_position.distance_to(PlayerRef.global_position) > attack_radius:
			set_movement_target(PlayerRef.global_position)
		else:
			current_state = state.ATTACK
			set_movement_target(global_position)


func _physics_process(delta: float) -> void:
	if NavigationServer2D.map_get_iteration_id(NavAgent.get_navigation_map()) == 0:
		return
	if NavAgent.is_navigation_finished():
		return
	

	
	movement_delta = speed * delta
	var next_path_position: Vector2 = NavAgent.get_next_path_position()
	$Sprite.look_at(next_path_position)
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
	if NavAgent.avoidance_enabled:
		NavAgent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)

func set_movement_target(movement_target: Vector2):
	NavAgent.set_target_position(movement_target)


func take_damage(_damage: int):
	#print(current_state)
	if current_state == state.IDLE or current_state == state.WANDER:
		%Anims.play("Fight")
		#print(shielded)
		%SwordCollision.set_deferred("disabled",false)
		if shielded != 2:
			%ShieldCollision.set_deferred("disabled",false)
			#print(%ShieldCollision.disabled)
	$Hurt.play("Hurt")
	health -= _damage
	current_state = state.CHASE
	$ProgressBar.show()
	

func on_health_changed(value):
	health = value
	$ProgressBar.value = health
	if health <= 0:
		var audio_player = AutoDeleteAudio.new(death_sound)
		var blood_splat = splatter.instantiate()
		blood_splat.global_position = global_position
		#audio_player.volume_db = -12
		get_parent().add_child(blood_splat)
		get_parent().add_child(audio_player)
		
		GameManager.level_kills += 1
		queue_free()


func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(0.5,3.5)
	if current_state == state.IDLE:
		current_state = state.WANDER
		#randf_range(-30,30)
		var wander_target:=	Vector2(global_position.x+randf_range(-50,50),global_position.y+randf_range(-50,50))
		set_movement_target(wander_target)
	if current_state == state.WANDER and not NavAgent.is_target_reachable:
		var wander_target:=	Vector2(global_position.x+randf_range(-50,50),global_position.y+randf_range(-50,50))
		set_movement_target(wander_target)


func _on_nav_agent_target_reached() -> void:
	match current_state:
		state.WANDER:
			current_state = state.IDLE
		state.ATTACK:
			$Anims.play("Attack")


func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Attack":
			current_state = state.CHASE


func _on_sword_hit(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
