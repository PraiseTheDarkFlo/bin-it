extends Area2D

@onready var level_state: Node = %LevelState


#end of map which resets the player when not hitting the trashcans
func _on_body_entered(body: Node2D) -> void:
	level_state.reset_streak()
	level_state.item_counter += 1
	body.respawn()
	
	
