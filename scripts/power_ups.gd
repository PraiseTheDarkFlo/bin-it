extends Node

@onready var level_state: Node = %LevelState
var PowerUpScene = preload("res://scenes/powerUp.tscn")

var min_spawn = Vector2(-255,-255)
var max_spawn = Vector2(185,169)

var powerups = {
	"slow": {
		"chance": 0.5, #chance to spawn
		"lower_bound": 0, #starts spawning after 0 items
		"sprite": null, #sprite for the power_up
		"action": func(): level_state.slowdown.emit() #the function which gots called if the power_up takes action
	},
	"speed": {
		"chance": 0.05,
		"lower_bound": 30,
		"sprite": null,
		"action": func(): print("speed!")
	}
}

func random_spawn() -> Vector2:
	var x = randf_range(min_spawn.x, max_spawn.x)
	var y = randf_range(min_spawn.y, max_spawn.y)
	return Vector2(x, y)
	
func maybe_spawn_powerup():
	for name in powerups.keys():
		var data = powerups[name]
		if level_state.item_counter >= data["lower_bound"]:	
			if randf() < data["chance"]:
				var newPowerUp = PowerUpScene.instantiate()
				newPowerUp.change_sprite(data["sprite"])
				newPowerUp.effect = name
				newPowerUp.position = random_spawn()
				add_child(newPowerUp)
				

func _on_timer_timeout() -> void:
	maybe_spawn_powerup()
	
func get_action(name: String) -> Callable:
	if powerups != null:
		if name in powerups.keys():
			return powerups[name]["action"]
	return Callable()
