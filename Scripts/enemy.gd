extends CharacterBody2D

enum state {IDLE, WANDER, CHASE, ATTACK}

@export var speed := 170
@export var damage := 20
@export var health:= 100 : set = on_health_changed
@export var attack_radius := 100

@onready var NavAgent := get_node("%NavAgent")

var movement_delta: float
var PlayerRef: CharacterBody2D
var current_state:= state.IDLE


func _ready() -> void:
	PlayerRef = owner.get_node("Player")
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
	$Hurt.play("Hurt")
	health -= _damage
	current_state = state.CHASE
	

func on_health_changed(value):
	health = value
	$ProgressBar.value = health
	if health <= 0:
		queue_free()


func _on_timer_timeout() -> void:
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
