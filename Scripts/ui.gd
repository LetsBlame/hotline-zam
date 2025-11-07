extends CanvasLayer

@onready var round_timer = $AmmoContainer/RoundTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%L_Kills_Num.text = str(GameManager.level_kills) + " / " + str(GameManager.level_enemies)
	GameManager.Damaged.connect(on_health_update)
	GameManager.Kill.connect(on_kill)
	#GameManager.LevelChanged.connect(on_level_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_health_update():
	%Healthbar.value = GameManager.health
	
func on_kill():
	%L_Kills_Num.text = str(GameManager.level_kills) + " / " + str(GameManager.level_enemies)

#func on_level_change():
	#print("Hi")
	#round_timer.reset_timer()
	#round_timer.start_timer()
	
