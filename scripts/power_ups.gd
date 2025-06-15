extends Node

@onready var level_state: Node = %LevelState
var PowerUpScene = preload("res://scenes/powerUp.tscn")
@onready var player: CharacterBody2D = %Player

#spawnfield of the powerups
var min_spawn = 152
var max_spawn = 440

var xPositions: Array

var xPositionsOccupied: Dictionary

#the diffrent powerups or downs 
var powerups = {
	"slow": {
		"chance": 0.6, #chance to spawn
		"lower_bound": 0, #starts spawning after 0 items
		"animation_name": "slowdown", #sprite for the power_up
		"action": func(): level_state.slowdown.emit(), #the function which gots called if the power_up takes action
		"negative": false
	},
	"speed": {
		"chance": 0.8,
		"lower_bound": 0,
		"animation_name": "speedup",
		"action": func(): level_state.speedup.emit(),
		"negative": true
	},
	"streak up": {
		"chance": 0.8,
		"lower_bound": 0,
		"animation_name": "multiplierUp",
		"action": func(): level_state.increase_score_powerup.emit(),
		"negative": false
	},
	
	"streak down":{
		"chance": 0.6,
		"lower_bound": 0,
		"animation_name": "multiplierDown",
		
		"action": func(): level_state.halve_score_powerup.emit(),
		"negative": true
	}
}

#random selects a point in the spawnfield for the new powerup to spawn
func random_spawn() -> Variant:
	print(xPositionsOccupied)
	var possiblexPositions = xPositionsOccupied.keys().filter(func(k): return xPositionsOccupied[k] == false and k!=int(player.position.x))
	print(possiblexPositions)
	if possiblexPositions.is_empty():
		return null
	var x = possiblexPositions.pick_random()
	var y = randf_range(min_spawn, max_spawn)
	return Vector2(x, y)
	
#calculatios if a powerup should spawn and if spawns it at a random position	
func maybe_spawn_powerup():
	if level_state.power_ups_on:
		var keys = powerups.keys()
		keys.shuffle()
		for name in keys:
			var data = powerups[name]
			if not level_state.negative_power_ups_on:
				if data["negative"]:
					continue
			if level_state.item_counter >= data["lower_bound"]:	
				if randf() < data["chance"]:
					var newPowerUp = PowerUpScene.instantiate()
					newPowerUp.initial_animation_name=(data["animation_name"])
					newPowerUp.effect = name
					var position = random_spawn()
					if position == null:
						return
					newPowerUp.position = position 
					add_child(newPowerUp)
					xPositionsOccupied[int(position.x)] = true
					#return
				

#timer how often the powerup spawing should be checked
func _on_timer_timeout() -> void:
	maybe_spawn_powerup()

#handels the giving of the function which is the action the powerups have
func get_action(name: String) -> Callable:
	if powerups != null:
		if name in powerups.keys():
			return powerups[name]["action"]
	return Callable()


func init_xPositionsOccupied() -> void:
	for position in xPositions:
		xPositionsOccupied[position] = false
