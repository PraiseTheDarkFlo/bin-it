extends Area2D

@onready var level_state: Node = %LevelState

@onready var player: CharacterBody2D = $"../Player"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var garbage_type

#methode which handels when the player enters the trashcan
func _on_body_entered(body: Node2D) -> void:
	if garbage_type == player.garbage_type:
		level_state.item_counter += 1
		level_state.add_score()	
		body.respawn()
