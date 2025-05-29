extends Area2D

@onready var level_state: Node = %LevelState



func _on_body_entered(body: Node2D) -> void:
	level_state.reset_streak()
	level_state.item_counter += 1
	body.respawn()
	
	
