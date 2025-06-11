extends Node

@onready var level_state: Node = %LevelState
var PowerUpScene = preload("res://scenes/powerUp.tscn")

#spawnfield of the powerups
var min_spawn = -200
var max_spawn = 150

var xPositions = [0,100]

#the diffrent powerups or downs 
var powerups = {
	"slow": {
		"chance": 0.6, #chance to spawn
		"lower_bound": 0, #starts spawning after 0 items
		"animation_name": "slowdown", #sprite for the power_up
		"action": func(): level_state.slowdown.emit() #the function which gots called if the power_up takes action
	},
	"speed": {
		"chance": 0.8,
		"lower_bound": 30,
		"animation_name": "speedup",
		"action": func(): level_state.speedup.emit()
	},
	"streak up": {
		"chance": 0.8,
		"lower_bound": 0,
		"animation_name": "multiplierUp",
		"action": func(): level_state.increase_score_powerup.emit()
	},
	
	"streak down":{
		"chance": 0.6,
		"lower_bound": 0,
		"animation_name": "multiplierDown",
		"action": func(): level_state.halve_score_powerup.emit()
	}
}

#random selects a point in the spawnfield for the new powerup to spawn
func random_spawn() -> Vector2:
	var x = xPositions.pick_random()
	var y = randf_range(min_spawn, max_spawn)
	return Vector2(x, y)
	
#calculatios if a powerup should spawn and if spawns it at a random position	
func maybe_spawn_powerup():
	for name in powerups.keys():
		var data = powerups[name]
		if level_state.item_counter >= data["lower_bound"]:	
			if randf() < data["chance"]:
				var newPowerUp = PowerUpScene.instantiate()
				newPowerUp.initial_animation_name=(data["animation_name"])
				newPowerUp.effect = name
				newPowerUp.position = random_spawn()
				add_child(newPowerUp)
				

#timer how often the powerup spawing should be checked
func _on_timer_timeout() -> void:
	maybe_spawn_powerup()

#handels the giving of the function which is the action the powerups have
func get_action(name: String) -> Callable:
	if powerups != null:
		if name in powerups.keys():
			return powerups[name]["action"]
	return Callable()
