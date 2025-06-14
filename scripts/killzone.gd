extends Area2D

@onready var level_state: Node = %LevelState
@onready var player: CharacterBody2D = %Player


#end of map which resets the player when not hitting the trashcans
func _on_body_entered(body: Node2D) -> void:
	if player.garbage_type==level_state.garbage_types.PAPER:
		level_state.paperParticles()
	elif player.garbage_type==level_state.garbage_types.YELLOW:
		level_state.yellowParticles()
	elif player.garbage_type==level_state.garbage_types.REST:
		level_state.restParticles()
	elif player.garbage_type==level_state.garbage_types.BIO:
		level_state.bioParticles()
	level_state.reset_streak()
	level_state.item_counter += 1
	body.respawn()
	
	
