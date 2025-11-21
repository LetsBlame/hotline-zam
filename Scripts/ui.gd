extends CanvasLayer

@onready var round_timer = $AmmoContainer/RoundTimer

func _ready() -> void:
	%L_Kills_Num.text = str(GameManager.level_kills) + " / " + str(GameManager.level_enemies)
	GameManager.Damaged.connect(on_health_update)
	GameManager.Kill.connect(on_kill)


func on_health_update():
	%Healthbar.value = GameManager.health


func on_kill():
	%L_Kills_Num.text = str(GameManager.level_kills) + " / " + str(GameManager.level_enemies)
